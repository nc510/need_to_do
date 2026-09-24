"""订单支付状态确认与履约（视图与管理命令共用）。

会员权益落在 quiz.Profile 的 member_start_time / member_expire_time 上，
不额外维护会员状态表，与站点原有的会员机制保持一致。
"""

from datetime import timedelta
from decimal import Decimal, InvalidOperation

from django.conf import settings
from django.db import transaction
from django.utils import timezone

from quiz.models import Profile

from .alipay_client import query_trade
from .models import Order

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


def grant_membership(user, plan):
    """开通/续期会员：写 Profile 的会员有效期。

    未过期则在原到期时间上顺延，已过期或首次开通则从现在起算。
    返回新的到期时间。
    """
    profile, _created = Profile.objects.get_or_create(user=user)
    now = timezone.now()
    fields = ['member_expire_time', 'updated_at']

    # 首次开通，或原先设置的是「未开始」，都以当前时间作为会员开始时间
    if not profile.member_start_time or profile.member_start_time > now:
        profile.member_start_time = now
        fields.append('member_start_time')

    base = profile.member_expire_time if profile.member_expire_time and profile.member_expire_time > now else now
    profile.member_expire_time = base + timedelta(days=plan.duration_days)
    profile.save(update_fields=fields)
    return profile.member_expire_time


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
