"""星币核心服务：原子加减余额、幂等发放、兑换与充值履约。

所有余额变更都在事务内对 StarAccount 加行锁（select_for_update），
并成对写入 StarTransaction 流水，保证「余额 = 流水累加」可审计。
充值履约复用会员支付的支付宝查单与常量（membership.services / membership.alipay_client）。
"""

import logging
import random
import re
import uuid
from datetime import timedelta

from django.db import transaction
from django.db.models import F, Sum
from django.utils import timezone

from membership.alipay_client import query_trade
from membership.services import (
    STATE_AMOUNT_MISMATCH,
    STATE_PAID,
    STATE_UNPAID,
    STATE_UNKNOWN,
    TRADE_NOT_EXIST,
    TRADE_SUCCESS_STATES,
    amount_matches,
    grant_membership_days,
    is_member_active,
)
from quiz.models import ConqueredQuestion, Profile

from .models import (
    AVATAR_FRAMES,
    NO_DISCOUNT_RATE,
    StarAccount,
    StarItem,
    StarItemUsage,
    StarLoginGift,
    StarLoginStreak,
    StarRechargeOrder,
    StarRedemption,
    StarTask,
    StarTaskRecord,
    StarTransaction,
)

logger = logging.getLogger(__name__)


class StarCoinError(Exception):
    """星币业务异常（余额不足、库存不足、超出限购等）"""


class InsufficientBalance(StarCoinError):
    """星币余额不足"""


def get_account(user):
    """获取（不存在则创建）用户的星币账户"""
    return StarAccount.get_or_create_for(user)


def _lock_account(user):
    """在事务内锁定并返回用户账户行，避免并发读-改-写竞态"""
    account, _created = StarAccount.objects.get_or_create(user=user)
    return StarAccount.objects.select_for_update().get(pk=account.pk)


@transaction.atomic
def earn(user, amount, kind, *, active=False, recharge=False,
         ref_type='', ref_id='', remark=''):
    """增加星币并写流水。

    active=True 时同步累加 active_earned（星力榜口径）；
    recharge=True 时同步累加 recharge_earned。
    返回 (account, transaction)。
    """
    amount = int(amount)
    if amount <= 0:
        raise StarCoinError('发放星币数量必须为正整数')

    account = _lock_account(user)
    account.balance += amount
    fields = ['balance', 'updated_at']
    if active:
        account.active_earned += amount
        fields.append('active_earned')
    if recharge:
        account.recharge_earned += amount
        fields.append('recharge_earned')
    account.save(update_fields=fields)

    tx = StarTransaction.objects.create(
        user=user, amount=amount, balance_after=account.balance, kind=kind,
        ref_type=ref_type, ref_id=str(ref_id), remark=remark)
    return account, tx


@transaction.atomic
def spend(user, amount, kind=StarTransaction.KIND_REDEEM,
          ref_type='', ref_id='', remark=''):
    """扣减星币并写流水；余额不足抛 InsufficientBalance。返回 (account, transaction)。"""
    amount = int(amount)
    if amount <= 0:
        raise StarCoinError('扣减星币数量必须为正整数')

    account = _lock_account(user)
    if account.balance < amount:
        raise InsufficientBalance(
            f'星币不足（当前 {account.balance}，需要 {amount}）')

    account.balance -= amount
    account.total_spent += amount
    account.save(update_fields=['balance', 'total_spent', 'updated_at'])

    tx = StarTransaction.objects.create(
        user=user, amount=-amount, balance_after=account.balance, kind=kind,
        ref_type=ref_type, ref_id=str(ref_id), remark=remark)
    return account, tx


def grant_task_reward(user, code, *, score_percent=None, period_key=None):
    """按任务配置发放活跃奖励（幂等）。

    返回实际发放的星币数；未配置 / 未启用 / 本周期已发 / 未达标时返回 None。
    score_percent 仅用于「试卷达标」任务的阈值判定。
    period_key 仅「里程碑」周期需要：由调用方按连续轮次生成，表示本次里程碑的唯一周期。
    """
    task = StarTask.objects.filter(code=code, is_active=True).first()
    if task is None:
        return None

    if score_percent is not None and task.threshold:
        try:
            if float(score_percent) < task.threshold:
                return None
        except (TypeError, ValueError):
            return None

    today = timezone.localdate().isoformat()
    if task.period == StarTask.PERIOD_MILESTONE:
        # 里程碑：周期键由调用方按「本轮连续登录 + 第几轮里程碑」生成
        if not period_key:
            return None
    elif task.period == StarTask.PERIOD_ONCE:
        period_key = 'once'
    elif task.period == StarTask.PERIOD_DAILY:
        period_key = today
    else:
        # 每次触发：以日期前缀 + 随机串作为周期键，便于按日期统计每日次数
        if task.daily_limit:
            granted_today = StarTaskRecord.objects.filter(
                user=user, task=task, period_key__startswith=today).count()
            if granted_today >= task.daily_limit:
                return None
        period_key = f'{today}-{uuid.uuid4().hex[:10]}'

    if task.reward_coins <= 0:
        return None

    try:
        with transaction.atomic():
            record, created = StarTaskRecord.objects.get_or_create(
                user=user, task=task, period_key=period_key,
                defaults={'reward_coins': task.reward_coins})
            if not created:
                return None
            earn(user, task.reward_coins, StarTransaction.KIND_ACTIVE, active=True,
                 ref_type='task', ref_id=task.code, remark=task.name)
    except Exception:
        logger.exception('星币任务奖励发放失败：code=%s user=%s', code, getattr(user, 'id', None))
        return None
    return task.reward_coins


# ===== 连续登录 =====

def record_login(user):
    """记录一次登录并维护连续天数，返回 (streak, is_first_today)。

    同一天重复登录不重复累计；断签（距上次登录超过 1 天）从 1 重新累计。
    """
    today = timezone.localdate()
    with transaction.atomic():
        StarLoginStreak.objects.get_or_create(user=user)
        streak = StarLoginStreak.objects.select_for_update().get(user=user)
        if streak.last_login_date == today:
            return streak, False
        if streak.last_login_date == today - timedelta(days=1):
            streak.current_days += 1
        else:
            streak.current_days = 1
            streak.streak_start_date = today
        streak.last_login_date = today
        streak.longest_days = max(streak.longest_days, streak.current_days)
        streak.save(update_fields=['current_days', 'longest_days',
                                   'streak_start_date', 'last_login_date', 'updated_at'])
    return streak, True


def streak_milestone_key(streak, cycle_days):
    """生成里程碑周期键：本轮连续登录内每满 cycle_days 天为一个周期。

    例如连续第 7~13 天为第 1 个 7 天周期，第 14 天起进入第 2 个周期；
    配合 StarTaskRecord 的唯一约束，保证每个周期只发一次奖励。
    """
    start = streak.streak_start_date or timezone.localdate()
    cycle = max(streak.current_days, 0) // cycle_days
    return f'{start:%Y%m%d}-c{cycle}'


# ===== 充值订单履约 =====

def mark_order_paid(order_no, trade_no=''):
    """幂等地把星币充值订单置为已支付并到账星币。

    返回 (order, changed)：order 为 None 表示订单不存在，
    changed=False 表示此前已是已支付状态（重复回调不重复到账）。
    """
    with transaction.atomic():
        order = StarRechargeOrder.objects.select_for_update().filter(order_no=order_no).first()
        if order is None:
            return None, False
        if order.status == StarRechargeOrder.STATUS_PAID:
            return order, False

        order.status = StarRechargeOrder.STATUS_PAID
        if trade_no:
            order.trade_no = trade_no
        order.paid_at = timezone.now()
        order.save(update_fields=['status', 'trade_no', 'paid_at'])

        earn(order.user, order.coins, StarTransaction.KIND_RECHARGE, recharge=True,
             ref_type='recharge_order', ref_id=order.order_no,
             remark=f'星币充值-{order.package.name}')
        return order, True


def is_sync_due(order, min_age_seconds=60):
    """订单是否已到值得兜底查单的账龄（新订单支付宝侧必然查不到）"""
    age_seconds = (timezone.now() - order.created_at).total_seconds()
    return age_seconds >= min_age_seconds


def sync_order(order):
    """查单确认单笔星币充值订单，确认支付成功则到账。返回 (state, order)。"""
    if order.status == StarRechargeOrder.STATUS_PAID:
        return STATE_PAID, order

    try:
        resp = query_trade(order.order_no)
    except Exception:
        logger.exception('星币充值订单查单失败：%s', order.order_no)
        return STATE_UNKNOWN, order

    if resp is None:
        return STATE_UNKNOWN, order

    if resp.get('code') != '10000':
        if resp.get('sub_code') == TRADE_NOT_EXIST:
            return STATE_UNPAID, order
        return STATE_UNKNOWN, order

    if resp.get('trade_status') not in TRADE_SUCCESS_STATES:
        return STATE_UNPAID, order
    if not amount_matches(order.amount, resp.get('total_amount', '')):
        return STATE_AMOUNT_MISMATCH, order

    order, _changed = mark_order_paid(order.order_no, resp.get('trade_no', ''))
    return STATE_PAID, order


# ===== 道具兑换 =====

@transaction.atomic
def redeem_item(user, item, quantity=1, contact='', user_remark=''):
    """兑换道具：校验上下架/库存/限购/余额 → 扣星币 + 扣库存 + 按效果类型发放。

    会员生效中的用户按道具配置的会员折扣计价；同时快照原价与折扣率，
    后台事后调整道具价格或折扣都不影响历史兑换记录的展示。

    发放分流（item.delivery_mode）：
    - manual：生成「待发放」记录，等后台核销（现状不变）；
    - instant：事务内立即生效并置为「已发放」，生效失败则整体回滚（星币自动退回）；
    - inventory：置为「已发放」（入背包），由用户在具体场景使用消耗。
    """
    try:
        quantity = int(quantity)
    except (TypeError, ValueError):
        raise StarCoinError('兑换数量无效')
    if quantity <= 0:
        raise StarCoinError('兑换数量必须大于 0')

    item = StarItem.objects.select_for_update().get(pk=item.pk)
    if not item.is_active:
        raise StarCoinError('该道具已下架')
    if not item.is_unlimited_stock and item.stock < quantity:
        raise StarCoinError('库存不足')

    if item.per_user_limit:
        bought = StarRedemption.objects.filter(
            user=user, item=item).exclude(
            status=StarRedemption.STATUS_CANCELLED).aggregate(n=Sum('quantity'))['n'] or 0
        if bought + quantity > item.per_user_limit:
            raise StarCoinError(f'每人限购 {item.per_user_limit} 件，您已兑换 {bought} 件')

    is_member = is_member_active(user)
    unit_price = item.price_for_member(is_member)
    discount_rate = item.effective_discount_rate if is_member else NO_DISCOUNT_RATE
    cost = unit_price * quantity
    original_cost = item.price_coins * quantity

    remark = f'兑换 {item.name}×{quantity}'
    if cost < original_cost:
        remark += f'（会员 {item.member_discount_label}）'
    spend(user, cost, StarTransaction.KIND_REDEEM, ref_type='item',
          ref_id=item.pk, remark=remark)

    if not item.is_unlimited_stock:
        item.stock -= quantity
        item.save(update_fields=['stock'])

    redemption = StarRedemption.objects.create(
        user=user, item=item, quantity=quantity,
        coins_cost=cost, original_coins=original_cost, discount_rate=discount_rate,
        contact=contact, user_remark=user_remark)

    if item.needs_manual_fulfill:
        return redemption

    # 即时生效型：先生效再落状态；生效抛错会连同扣币一起回滚
    if item.delivery_mode == StarItem.MODE_INSTANT:
        apply_instant_effect(user, item, redemption, quantity=quantity)
    redemption.status = StarRedemption.STATUS_FULFILLED
    redemption.fulfilled_at = timezone.now()
    redemption.admin_remark = ('系统自动发放（即时生效）'
                               if item.delivery_mode == StarItem.MODE_INSTANT
                               else '系统自动发放（已入背包）')
    redemption.save(update_fields=['status', 'fulfilled_at', 'admin_remark'])
    return redemption


# ===== 道具效果分发 =====

def _apply_member_card(user, item, redemption, quantity=1):
    """会员卡：按 payload['days'] × 数量 续期会员，返回生效明细。

    复用充值订单的续期口径（未过期顺延、已过期从现在起算），见 grant_membership_days。
    """
    days = int(item.effect_payload.get('days') or 0)
    if days <= 0:
        raise StarCoinError(f'道具「{item.name}」的会员天数配置有误，请联系管理员')
    total_days = days * quantity
    expire = grant_membership_days(user, total_days)
    return f'会员延长 {total_days} 天，到期 {timezone.localtime(expire):%Y-%m-%d %H:%M}'


def _apply_accuracy_reset(user, item, redemption, quantity=1):
    """正确率重置卡：仅清空累计作答题次与答对题次（正确率口径）。

    斩题数由去重表派生、总分/答题次数属累计荣誉，一律不动；
    重置后正确率榜因门槛（MIN_ANSWERS_FOR_ACCURACY_RANK）会暂时掉榜，前端已做二次确认。
    """
    if quantity != 1:
        raise StarCoinError(f'「{item.name}」一次只能兑换 1 张')
    profile, _created = Profile.objects.get_or_create(user=user)
    before = f'{profile.answered_correct}/{profile.answered_total}'
    if profile.answered_total or profile.answered_correct:
        profile.answered_total = 0
        profile.answered_correct = 0
        profile.save(update_fields=['answered_total', 'answered_correct', 'updated_at'])
    return f'正确率统计清零（重置前 答对/作答 = {before}）'


def _apply_conquer_card(user, item, redemption, quantity=1):
    """斩题卡：增加斩题加成并重算斩题数（口径 = 去重表条数 + 加成）。

    必须走 conquered_bonus 而不能直接改 conquered_count —— 答题提交与重建命令都会用
    「去重表条数 + 加成」整体覆盖 conquered_count，直接加会被下一次答题覆盖归零。
    """
    count = int(item.effect_payload.get('count') or 0)
    if count <= 0:
        raise StarCoinError(f'道具「{item.name}」的斩题加成配置有误，请联系管理员')
    profile, _created = Profile.objects.get_or_create(user=user)
    profile.conquered_bonus += count * quantity
    profile.conquered_count = (ConqueredQuestion.objects.filter(user=user).count()
                               + profile.conquered_bonus)
    profile.save(update_fields=['conquered_bonus', 'conquered_count', 'updated_at'])
    return f'斩题数 +{count * quantity}（现为 {profile.conquered_count}）'


# 即时生效型道具的处理器：effect_type -> callable(user, item, redemption, quantity) -> 明细文案
# 未注册的效果类型直接拒绝兑换，避免出现「扣了星币却没生效」。
INSTANT_EFFECT_HANDLERS = {
    StarItem.EFFECT_MEMBER: _apply_member_card,
    StarItem.EFFECT_ACCURACY_RESET: _apply_accuracy_reset,
    StarItem.EFFECT_CONQUER: _apply_conquer_card,
}


def apply_instant_effect(user, item, redemption, quantity=1):
    """执行即时生效型道具的效果（在 redeem_item 事务内调用）并写使用留痕"""
    handler = INSTANT_EFFECT_HANDLERS.get(item.effect_type)
    if handler is None:
        raise StarCoinError(f'道具「{item.name}」的功能尚未开放，请稍后再试')
    detail = handler(user, item, redemption, quantity=quantity) or ''
    StarItemUsage.objects.create(
        user=user, item=item, redemption=redemption, effect_type=item.effect_type,
        context=StarItem.MODE_INSTANT, detail=detail[:200])


@transaction.atomic
def consume_item(user, item, *, context='', detail=''):
    """使用一张背包使用型道具卡：扣减持有量并写使用流水，返回 StarItemUsage。

    持有量口径 = 已发放兑换的 (quantity - used_quantity) 之和，
    因此这里只需找到任意一条尚有余额的兑换记录并加一即可。
    """
    if not item.effect_type:
        raise StarCoinError('该道具由管理员核销发放，无需使用')

    redemption = (StarRedemption.objects
                  .select_for_update()
                  .filter(user=user, item=item, status=StarRedemption.STATUS_FULFILLED)
                  .filter(used_quantity__lt=F('quantity'))
                  .order_by('id')
                  .first())
    if redemption is None:
        raise StarCoinError(f'「{item.name}」数量不足，请先到道具商城兑换')

    redemption.used_quantity += 1
    redemption.save(update_fields=['used_quantity'])
    return StarItemUsage.objects.create(
        user=user, item=item, redemption=redemption,
        effect_type=item.effect_type, context=context, detail=detail)


def available_quantity(user, item):
    """用户某道具的可用张数（已发放兑换剩余之和）"""
    total = (StarRedemption.objects
             .filter(user=user, item=item, status=StarRedemption.STATUS_FULFILLED)
             .aggregate(n=Sum(F('quantity') - F('used_quantity'))))['n']
    return total or 0


def get_active_item_by_effect(effect_type):
    """按效果类型取上架中的道具（同一效果同时只支持一个在售道具）"""
    return StarItem.objects.filter(effect_type=effect_type, is_active=True).first()


# ===== 系统赠送道具 / 每日登录赠礼 =====

@transaction.atomic
def grant_item(user, item, quantity=1, *, remark='', admin_remark='系统赠送', operator=None):
    """系统赠送道具：直接入背包，不扣星币、不扣库存、不受限购。

    生成一条「已发放」的兑换记录，与星币兑换所得完全同源 ——
    背包余量、答题页张数、available_quantity 都按同一口径统计。
    后台赠送（operator 非空）时一并留下操作人与备注，便于审计。
    """
    quantity = int(quantity)
    if quantity <= 0:
        raise StarCoinError('赠送道具数量必须为正整数')
    return StarRedemption.objects.create(
        user=user, item=item, quantity=quantity,
        coins_cost=0, original_coins=0, discount_rate=NO_DISCOUNT_RATE,
        status=StarRedemption.STATUS_FULFILLED,
        user_remark=remark[:200], admin_remark=admin_remark[:200],
        fulfilled_by=operator, fulfilled_at=timezone.now())


def grant_login_gift(user):
    """每日登录赠礼：按后台「每日登录赠礼」配置赠送道具（免费 / 会员两档张数）。

    幂等：同一天只发一次（以 StarLoginStreak.last_gift_date 为准），
    因此登录动作与「当天首次访问页面」两条触发路径可以安全地重复调用。
    返回本次赠礼提示文案（当天已发过 / 无可赠道具时返回空串），由调用方展示给用户。
    仅赠送「上架中」的道具：下架道具在前台各场景都不出现，发了也无法使用。
    """
    today = timezone.localdate()
    # 绝大多数请求会命中这条快速路径，避免每次访问都去锁行
    streak = StarLoginStreak.objects.filter(user=user).first()
    if streak is not None and streak.last_gift_date == today:
        return ''

    with transaction.atomic():
        streak, _ = StarLoginStreak.objects.select_for_update().get_or_create(user=user)
        if streak.last_gift_date == today:
            return ''

        is_member = is_member_active(user)
        remark = '每日登录赠送（会员）' if is_member else '每日登录赠送（免费用户）'
        granted = []
        gifts = (StarLoginGift.objects.filter(is_active=True)
                 .select_related('item').order_by('sort_order', 'id'))
        for gift in gifts:
            quantity = gift.quantity_for(is_member)
            if quantity <= 0:
                continue
            if not gift.item.is_active:
                logger.warning('每日登录赠礼跳过（道具已下架）：%s', gift.item.name)
                continue
            grant_item(user, gift.item, quantity, remark=remark)
            granted.append(f'{gift.item.icon}「{gift.item.name}」×{quantity}')

        streak.last_gift_date = today
        streak.save(update_fields=['last_gift_date'])

    if not granted:
        return ''
    tier = '会员' if is_member else '免费用户'
    return f'🎁 每日登录赠礼（{tier}）已到账：{"、".join(granted)}，已放入星币中心背包'


# ===== 背包使用型道具 =====

# 改名卡：昵称长度与禁用符号（去首尾空格后校验）
RENAME_MIN_LEN = 2
RENAME_MAX_LEN = 12
_RENAME_FORBIDDEN_CHARS = set('<>/\\"\'`&=%$#@!*()[]{}|~^;:,?、，。！？')


def _clean_rename(raw):
    """校验并返回合规的新昵称（2~12 字、无空格、无特殊符号）"""
    name = (raw or '').strip()
    if not RENAME_MIN_LEN <= len(name) <= RENAME_MAX_LEN:
        raise StarCoinError(
            f'昵称需 {RENAME_MIN_LEN}~{RENAME_MAX_LEN} 个字（当前 {len(name)} 个）')
    if any(ch.isspace() for ch in name):
        raise StarCoinError('昵称不能包含空格')
    if any(ch in _RENAME_FORBIDDEN_CHARS for ch in name):
        raise StarCoinError('昵称包含不允许的符号，请换一个')
    return name


def _use_rename_card(user, item, payload):
    """改名卡：把新昵称写入 Profile.name（榜单展示名优先读它，改完立即生效）

    不动 User.first_name（那是注册姓名），避免与注册流程互相污染。
    """
    profile, _created = Profile.objects.get_or_create(user=user)
    new_name = _clean_rename(payload.get('new_name'))
    old_name = (profile.name or user.first_name or user.username or '').strip()
    if new_name == old_name:
        raise StarCoinError('新昵称与当前昵称相同，无需改名')
    profile.name = new_name
    profile.save(update_fields=['name', 'updated_at'])
    return f'{old_name} → {new_name}'


def _use_avatar_frame(user, item, payload):
    """头像框：把选中的样式 key 写入 Profile.avatar_frame"""
    frame = (payload.get('frame') or '').strip()
    labels = dict(AVATAR_FRAMES)
    if frame not in labels:
        raise StarCoinError('请选择一个有效的头像框样式')
    profile, _created = Profile.objects.get_or_create(user=user)
    profile.avatar_frame = frame
    profile.save(update_fields=['avatar_frame', 'updated_at'])
    return f'头像框已切换为 {labels[frame]}'


# 背包使用型道具的处理器：effect_type -> callable(user, item, payload) -> 明细文案
# 组卷卡 / 提示卡不在此处：它们在具体场景（错题本组卷、答题页提示）里直接 consume_item。
INVENTORY_EFFECT_HANDLERS = {
    StarItem.EFFECT_RENAME: _use_rename_card,
    StarItem.EFFECT_AVATAR_FRAME: _use_avatar_frame,
}


@transaction.atomic
def use_inventory_item(user, item, *, payload=None, context='backpack'):
    """使用一张背包使用型道具（背包「使用」入口统一调用）。

    先扣张数再执行效果，两者同一事务：效果校验失败会连同扣减一起回滚，不会白扣一张。
    """
    if item.delivery_mode != StarItem.MODE_INVENTORY:
        raise StarCoinError(f'「{item.name}」不是背包使用型道具')
    handler = INVENTORY_EFFECT_HANDLERS.get(item.effect_type)
    if handler is None:
        raise StarCoinError(f'道具「{item.name}」暂不支持在背包中使用')

    usage = consume_item(user, item, context=context)
    detail = handler(user, item, payload or {})
    usage.detail = detail[:200]
    usage.save(update_fields=['detail'])
    return detail


# ===== 答案提示卡：提示文案生成 =====

# 解析提示只给前 N 字，避免把完整解析（可能含答案）直接给出去
HINT_EXPLANATION_CHARS = 40


def _explanation_leaks_answer(question, snippet, option_keys):
    """判断解析片段是否点名了答案（「答案是A」「选项C错误」「因此选D」）。

    解析几乎都在解释「正确项」，因此只要片段里出现任一选项字母就弃用解析策略：
    宁可提示信息少一点，也不能把答案送出去。
    """
    if '答案' in snippet:
        return True
    if question.type == 3 and ('正确' in snippet or '错误' in snippet):
        return True
    return any(re.search(r'(?<![A-Za-z0-9])' + re.escape(key) + r'(?![A-Za-z0-9])', snippet)
               for key in option_keys)


def build_hint_text(question):
    """生成一条不泄露最终答案的提示。

    优先级：题目有解析且开头未点名答案 → 解析前 40 字；
    否则选择题 → 排除一个错误选项；判断题无选项可排除 → 只给题干要点与常见陷阱提醒。
    """
    content = re.sub(r'\s+', ' ', question.content or '').strip()
    explanation = re.sub(r'\s+', ' ', question.explanation or '').strip()
    options = question.options or {}
    correct_keys = {ch for ch in str(question.correct_answer or '').upper() if ch.isalnum()}

    if explanation:
        snippet = explanation[:HINT_EXPLANATION_CHARS]
        if not _explanation_leaks_answer(question, snippet, sorted(options) or sorted(correct_keys)):
            return f'📖 解析提示：{snippet}{"…" if len(explanation) > HINT_EXPLANATION_CHARS else ""}'

    if question.type in (1, 2) and options:
        wrong_keys = [key for key in sorted(options) if key.upper() not in correct_keys]
        # 至少要能排除 2 个错误项才提示，否则等于直接给答案（单选只剩它一个）
        if len(wrong_keys) > 1:
            bad_key = random.choice(wrong_keys)
            return f'💡 提示：可以排除选项 {bad_key.upper()}（{options[bad_key]}）'
        return '💡 提示：本题可选范围较小，无法安全排除选项，请从题干关键条件入手。'

    if question.type == 3:
        return (f'💡 提示：本题为判断题，题干要点「{content[:HINT_EXPLANATION_CHARS]}」；'
                '注意「一定」「都」「绝不」等绝对化表述多为错误。')

    return '💡 提示：请仔细阅读题干中的限定条件，逐项排除明显不成立的描述。'


@transaction.atomic
def fulfill_redemption(redemption, operator=None, admin_remark=''):
    """后台核销：标记兑换记录为已发放"""
    redemption = StarRedemption.objects.select_for_update().get(pk=redemption.pk)
    if redemption.status != StarRedemption.STATUS_PENDING:
        raise StarCoinError('仅「待发放」的记录可以核销')
    redemption.status = StarRedemption.STATUS_FULFILLED
    redemption.fulfilled_by = operator
    redemption.fulfilled_at = timezone.now()
    if admin_remark:
        redemption.admin_remark = admin_remark
    redemption.save(update_fields=['status', 'fulfilled_by', 'fulfilled_at', 'admin_remark'])
    return redemption


@transaction.atomic
def cancel_redemption(redemption, operator=None, admin_remark=''):
    """后台取消：退回星币并返还库存"""
    redemption = StarRedemption.objects.select_for_update().get(pk=redemption.pk)
    if redemption.status != StarRedemption.STATUS_PENDING:
        raise StarCoinError('仅「待发放」的记录可以取消')

    redemption.status = StarRedemption.STATUS_CANCELLED
    redemption.fulfilled_by = operator
    redemption.fulfilled_at = timezone.now()
    if admin_remark:
        redemption.admin_remark = admin_remark
    redemption.save(update_fields=['status', 'fulfilled_by', 'fulfilled_at', 'admin_remark'])

    earn(redemption.user, redemption.coins_cost, StarTransaction.KIND_REFUND,
         ref_type='redemption', ref_id=redemption.pk,
         remark=f'兑换取消退回：{redemption.item.name}×{redemption.quantity}')

    item = StarItem.objects.select_for_update().get(pk=redemption.item_id)
    if not item.is_unlimited_stock:
        item.stock += redemption.quantity
        item.save(update_fields=['stock'])
    return redemption
