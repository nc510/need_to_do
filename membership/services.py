"""订单支付状态确认与履约（视图与管理命令共用）。

会员权益落在 quiz.Profile 的 member_start_time / member_expire_time 上，
不额外维护会员状态表，与站点原有的会员机制保持一致。
另含卡密（高级功能 / 星币）的生成与兑换：卡密由第三方渠道售出，本站只负责核销。
"""

import re
from datetime import timedelta
from decimal import Decimal, InvalidOperation

from django.conf import settings
from django.db import transaction
from django.utils import timezone

from quiz.models import Profile

from .alipay_client import query_trade
from .models import CardKey, Order

# 支付宝中代表支付成功的交易状态
TRADE_SUCCESS_STATES = ('TRADE_SUCCESS', 'TRADE_FINISHED')

# 支付宝侧没有该交易时的 sub_code（属于「尚未支付」，不是查询失败）
TRADE_NOT_EXIST = 'ACQ.TRADE_NOT_EXIST'

# sync_order 的确认结果
STATE_PAID = 'paid'
STATE_UNPAID = 'unpaid'
STATE_AMOUNT_MISMATCH = 'amount_mismatch'
STATE_UNKNOWN = 'unknown'


def amount_matches(expected, actual):
    """按分比对金额，避免浮点/格式差异导致误判。"""
    try:
        return Decimal(str(actual)).quantize(Decimal('0.01')) == Decimal(expected).quantize(Decimal('0.01'))
    except (InvalidOperation, TypeError, ValueError):
        return False


def is_member_active(user):
    """会员权益是否生效中（付费会员）。

    口径复用 Profile.member_status_code：未设置 / 未开始 / 已到期一律不算会员。
    这里直接查库取 Profile，不用 user.profile 反向缓存 —— 缓存可能是本请求早期
    读到的旧值，会让会员状态判断滞后。
    """
    if user is None or not getattr(user, 'is_authenticated', False):
        return False
    profile = Profile.objects.filter(user=user).first()
    return bool(profile and profile.member_status_code == 'active')


def grant_membership_days(user, days):
    """按天数开通/续期会员：写 Profile 的会员有效期，返回新的到期时间。

    未过期则在原到期时间上顺延，已过期或首次开通则从现在起算。
    充值订单履约（grant_membership）与道具「会员卡」共用本函数，保证续期口径一致。
    """
    days = int(days)
    if days <= 0:
        raise ValueError('会员天数必须大于 0')

    profile, _created = Profile.objects.get_or_create(user=user)
    now = timezone.now()
    fields = ['member_expire_time', 'updated_at']

    # 首次开通，或原先设置的是「未开始」，都以当前时间作为会员开始时间
    if not profile.member_start_time or profile.member_start_time > now:
        profile.member_start_time = now
        fields.append('member_start_time')

    base = profile.member_expire_time if profile.member_expire_time and profile.member_expire_time > now else now
    profile.member_expire_time = base + timedelta(days=days)
    profile.save(update_fields=fields)
    return profile.member_expire_time


def grant_membership(user, plan):
    """按套餐时长开通/续期会员，返回新的到期时间。"""
    return grant_membership_days(user, plan.duration_days)


def raw_trade_response(order_no):
    """调用支付宝查单接口，返回响应字典；网络异常时返回 None。

    注意：交易不存在时 SDK 不抛异常，而是返回 code=40004 的响应字典。
    """
    try:
        return query_trade(order_no)
    except Exception:
        return None


def mark_order_paid(order_no, trade_no=''):
    """幂等地把订单置为已支付并开通/续期会员。

    返回 (order, changed)：order 为 None 表示订单不存在，
    changed=False 表示订单此前已是已支付状态。
    """
    with transaction.atomic():
        order = Order.objects.select_for_update().filter(order_no=order_no).first()
        if order is None:
            return None, False
        if order.status == Order.STATUS_PAID:
            return order, False

        order.status = Order.STATUS_PAID
        if trade_no:
            order.trade_no = trade_no
        order.paid_at = timezone.now()
        order.save(update_fields=['status', 'trade_no', 'paid_at'])

        grant_membership(order.user, order.plan)
        return order, True


def is_sync_due(order):
    """订单是否已到值得兜底查单的账龄。

    刚创建的订单支付宝侧必然查不到，跳过查询避免无意义的接口调用。
    """
    age_seconds = (timezone.now() - order.created_at).total_seconds()
    return age_seconds >= settings.ORDER_SYNC_MIN_AGE_SECONDS


def sync_order(order):
    """查单确认单笔订单，确认支付成功则履约。

    返回 (state, order)：state 为 STATE_* 之一。
    """
    if order.status == Order.STATUS_PAID:
        return STATE_PAID, order

    resp = raw_trade_response(order.order_no)
    if resp is None:
        return STATE_UNKNOWN, order

    if resp.get('code') != '10000':
        # 交易不存在说明还没付款，其它错误码视为查询失败
        if resp.get('sub_code') == TRADE_NOT_EXIST:
            return STATE_UNPAID, order
        return STATE_UNKNOWN, order

    if resp.get('trade_status') not in TRADE_SUCCESS_STATES:
        return STATE_UNPAID, order
    if not amount_matches(order.amount, resp.get('total_amount', '')):
        return STATE_AMOUNT_MISMATCH, order

    order, _changed = mark_order_paid(order.order_no, resp.get('trade_no', ''))
    return STATE_PAID, order


def sync_pending_orders(limit=None):
    """批量补单：对未支付订单逐一查单确认，返回各状态计数。"""
    counts = {
        'total': 0,
        STATE_PAID: 0,
        STATE_UNPAID: 0,
        STATE_AMOUNT_MISMATCH: 0,
        STATE_UNKNOWN: 0,
    }
    orders = Order.objects.filter(status=Order.STATUS_PENDING).order_by('id')
    if limit:
        orders = orders[:limit]

    for order in orders:
        state, _order = sync_order(order)
        counts['total'] += 1
        counts[state] += 1
    return counts


# ===== 卡密 =====

# 卡密生成时的最大重试次数（随机码碰撞概率极低，重试仅作兜底）
CARD_CODE_MAX_ATTEMPTS = 20

# 规范化时剔除的字符：只保留数字与大写字母，用户输入的空格、连字符、全角符号都会被忽略
_CARD_CODE_STRIP_RE = re.compile(r'[^0-9A-Z]')


class CardKeyError(Exception):
    """卡密业务异常（卡密无效 / 已使用 / 已作废 / 类型不符等）"""


def normalize_card_code(raw):
    """把用户输入的卡密规范化成存储口径（大写字母 + 数字，忽略空格与连字符）"""
    return _CARD_CODE_STRIP_RE.sub('', (raw or '').upper())


def _unique_card_code():
    """生成一个库里不存在的随机卡密"""
    for _ in range(CARD_CODE_MAX_ATTEMPTS):
        code = CardKey.generate_code()
        if not CardKey.objects.filter(code=code).exists():
            return code
    raise CardKeyError('卡密生成失败，请重试')


def generate_card_keys(kind, quantity, *, duration_days=0, coins=0,
                       remark='', operator=None, batch_no=''):
    """批量生成卡密，返回 (batch_no, [CardKey])。

    一次生成归属同一个批次号，便于按批次导出给第三方渠道（如淘宝自动发货）上架。
    """
    try:
        quantity = int(quantity)
    except (TypeError, ValueError):
        raise CardKeyError('生成数量无效')
    if quantity <= 0:
        raise CardKeyError('生成数量必须大于 0')
    if kind not in dict(CardKey.KIND_CHOICES):
        raise CardKeyError('卡密类型无效')

    duration_days = int(duration_days or 0)
    coins = int(coins or 0)
    if kind == CardKey.KIND_MEMBER and duration_days <= 0:
        raise CardKeyError('高级功能卡密必须填写大于 0 的有效天数')
    if kind == CardKey.KIND_STARCOIN and coins <= 0:
        raise CardKeyError('星币卡密必须填写大于 0 的到账星币')

    batch_no = batch_no or timezone.now().strftime('B%Y%m%d%H%M%S')
    cards = []
    with transaction.atomic():
        for _ in range(quantity):
            cards.append(CardKey.objects.create(
                code=_unique_card_code(), kind=kind,
                duration_days=duration_days if kind == CardKey.KIND_MEMBER else 0,
                coins=coins if kind == CardKey.KIND_STARCOIN else 0,
                batch_no=batch_no, remark=remark[:100], created_by=operator))
    return batch_no, cards


@transaction.atomic
def redeem_card_key(user, raw_code, kind=None):
    """核销卡密并立即发放权益，返回 (card, detail)。

    kind 非空时校验卡密类型（避免把星币卡密填到高级功能兑换入口）；
    全程行锁 + 事务，保证同一张卡密并发兑换只会成功一次。
    """
    code = normalize_card_code(raw_code)
    if not code:
        raise CardKeyError('请输入卡密')

    card = CardKey.objects.select_for_update().filter(code=code).first()
    if card is None:
        raise CardKeyError('卡密无效，请核对后重新输入')
    if kind and card.kind != kind:
        raise CardKeyError('该卡密不适用于本页面，请到对应的兑换入口使用')
    if card.status == CardKey.STATUS_DISABLED:
        raise CardKeyError('该卡密已作废，请联系客服')
    if card.status == CardKey.STATUS_USED:
        used_at = timezone.localtime(card.used_at).strftime('%Y-%m-%d %H:%M') if card.used_at else ''
        raise CardKeyError(f'该卡密已于 {used_at} 使用过，不能重复兑换')

    if card.kind == CardKey.KIND_MEMBER:
        if card.duration_days <= 0:
            raise CardKeyError('该卡密配置有误，请联系客服')
        expire = grant_membership_days(user, card.duration_days)
        detail = (f'高级功能已延长 {card.duration_days} 天，'
                  f'到期时间 {timezone.localtime(expire):%Y-%m-%d %H:%M}')
    else:
        if card.coins <= 0:
            raise CardKeyError('该卡密配置有误，请联系客服')
        # 延迟导入：starcoin.services 依赖本模块，模块级导入会形成循环引用
        from starcoin.models import StarTransaction
        from starcoin.services import earn
        earn(user, card.coins, StarTransaction.KIND_RECHARGE, recharge=True,
             ref_type='card_key', ref_id=card.code,
             remark=f'卡密兑换-{card.benefit_label}')
        detail = f'已到账 {card.coins} 星币'

    card.status = CardKey.STATUS_USED
    card.used_by = user
    card.used_at = timezone.now()
    card.save(update_fields=['status', 'used_by', 'used_at'])
    return card, detail
