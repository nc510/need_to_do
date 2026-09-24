"""星币核心服务：原子加减余额、幂等发放、兑换与充值履约。

所有余额变更都在事务内对 StarAccount 加行锁（select_for_update），
并成对写入 StarTransaction 流水，保证「余额 = 流水累加」可审计。
充值履约复用会员支付的支付宝查单与常量（membership.services / membership.alipay_client）。
"""

import logging
import uuid
from datetime import timedelta

from django.db import transaction
from django.db.models import Sum
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
    is_member_active,
)

from .models import (
    NO_DISCOUNT_RATE,
    StarAccount,
    StarItem,
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
    """兑换道具：校验上下架/库存/限购/余额 → 扣星币 + 扣库存 + 生成待发放记录。

    会员生效中的用户按道具配置的会员折扣计价；同时快照原价与折扣率，
    后台事后调整道具价格或折扣都不影响历史兑换记录的展示。
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

    return StarRedemption.objects.create(
        user=user, item=item, quantity=quantity,
        coins_cost=cost, original_coins=original_cost, discount_rate=discount_rate,
        contact=contact, user_remark=user_remark)


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
