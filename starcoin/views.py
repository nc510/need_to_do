"""星币前台视图：星币中心、任务、星耀榜、道具商城、充值支付、流水与兑换记录。"""

from django.conf import settings
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.db.models import Q, Sum
from django.http import HttpResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

from membership.alipay_client import build_pay_url, get_alipay
from membership.services import (
    STATE_AMOUNT_MISMATCH,
    STATE_PAID,
    TRADE_SUCCESS_STATES,
    amount_matches,
    is_member_active,
)
from quiz.utils import (
    leaderboard_share_response,
    render_leaderboard_share_image,
    share_site_url,
)

from . import hooks as star_hooks
from .models import (
    StarAccount,
    StarItem,
    StarLoginStreak,
    StarPackage,
    StarRechargeOrder,
    StarRedemption,
    StarTask,
    StarTaskRecord,
    StarTransaction,
)
from .services import (
    StarCoinError,
    get_account,
    is_sync_due,
    mark_order_paid,
    redeem_item,
    sync_order,
)

# 榜单展示条数
LEADERBOARD_TOP_N = 10


# ===== 星币中心 =====

@login_required
def center(request):
    """星币中心：余额概览 + 我的道具 + 今日任务 + 最近流水 + 各功能入口"""
    account = get_account(request.user)
    tasks = StarTask.objects.filter(is_active=True).order_by('sort_order', 'id')
    streak = StarLoginStreak.objects.filter(user=request.user).first()
    task_states = _task_states(request.user, tasks, streak_days=streak.current_days if streak else 0)
    recent_transactions = StarTransaction.objects.filter(
        user=request.user).order_by('-id')[:6]
    return render(request, 'starcoin/center.html', {
        'account': account,
        'owned_items': _owned_items(request.user),
        'task_states': task_states,
        'login_streak': streak,
        'recent_transactions': recent_transactions,
        'pending_redemptions': StarRedemption.objects.filter(
            user=request.user, status=StarRedemption.STATUS_PENDING).count(),
    })


def _owned_items(user):
    """我的道具：把未取消的兑换按道具聚合，区分待发放 / 已发放数量。

    道具功能后续再扩展，这里先只做「持有展示」，让用户看到自己已兑换了什么。
    """
    rows = (StarRedemption.objects
            .filter(user=user)
            .exclude(status=StarRedemption.STATUS_CANCELLED)
            .order_by()  # 清空 Meta 默认排序，避免 id 进入 GROUP BY 破坏聚合
            .values('item_id', 'item__icon', 'item__name', 'item__description',
                    'item__category', 'item__sort_order', 'status')
            .annotate(qty=Sum('quantity')))
    owned = {}
    for row in rows:
        entry = owned.setdefault(row['item_id'], {
            'icon': row['item__icon'],
            'name': row['item__name'],
            'description': row['item__description'],
            'category': row['item__category'],
            'sort_order': row['item__sort_order'],
            'pending': 0,
            'fulfilled': 0,
            'total': 0,
        })
        entry[row['status']] = row['qty']
        entry['total'] += row['qty']
    return sorted(owned.values(), key=lambda e: (e['sort_order'], e['name']))


def _task_states(user, tasks, streak_days=0):
    """计算每个任务的完成状态，供前台展示。

    返回 [{'task', 'state', 'today_count', 'streak_days',
          'milestone_cycle', 'milestone_left'}]：
      state: done（本周期已完成）/ ready（可完成）/ auto（被动触发，无手动领取）
             / milestone（按连续登录天数判定）
    milestone_cycle / milestone_left 仅里程碑任务有值：周期天数 与 距下一轮还差几天。
    """
    today = timezone.localdate().isoformat()
    once_or_done = set(
        StarTaskRecord.objects.filter(user=user)
        .filter(Q(period_key='once') | Q(period_key__startswith=today))
        .values_list('task_id', flat=True))
    today_counts = {}
    for task_id, in (StarTaskRecord.objects.filter(user=user, period_key__startswith=today)
                     .values_list('task_id')):
        today_counts[task_id] = today_counts.get(task_id, 0) + 1

    states = []
    for task in tasks:
        cycle = task.milestone_cycle_days
        left = None
        if task.period == StarTask.PERIOD_MILESTONE:
            state = 'milestone'
            if cycle:
                remainder = streak_days % cycle
                left = 0 if (remainder == 0 and streak_days >= cycle) else cycle - remainder
        elif task.period == StarTask.PERIOD_UNLIMITED:
            state = 'auto'
        elif task.id in once_or_done:
            state = 'done'
        else:
            state = 'ready'
        states.append({
            'task': task,
            'state': state,
            'today_count': today_counts.get(task.id, 0),
            'streak_days': streak_days,
            'milestone_cycle': cycle,
            'milestone_left': left,
        })
    return states


# ===== 任务中心 =====

@login_required
def tasks(request):
    """星币任务中心：展示任务规则与完成进度"""
    task_list = StarTask.objects.filter(is_active=True).order_by('sort_order', 'id')
    return render(request, 'starcoin/tasks.html', {
        'task_states': _task_states(request.user, task_list),
        'account': get_account(request.user),
    })


# ===== 星耀榜（星力榜 + 星富榜）=====

def _display_name(account):
    """榜单展示名：优先 Profile.name，其次注册姓名，最后用户名"""
    profile = getattr(account.user, 'profile', None)
    name = getattr(profile, 'name', '') if profile else ''
    return (name or account.user.first_name or account.user.username or '').strip()


def _build_board(key, title, icon, value_field, order_by, queryset, user, top_n=LEADERBOARD_TOP_N):
    """构建单个榜单：Top N 条目 + 当前用户自己的名次"""
    entries = []
    for index, account in enumerate(queryset.order_by(*order_by)[:top_n], start=1):
        entries.append({
            'rank': index,
            'name': _display_name(account),
            'class_name': account.user.profile.class_obj.name if getattr(account.user, 'profile', None) and account.user.profile.class_obj else '',
            'value': getattr(account, value_field),
            'is_me': user.is_authenticated and account.user_id == user.id,
        })
    me = None
    if user.is_authenticated:
        mine = queryset.filter(user=user).first()
        if mine is not None:
            ordered_ids = list(queryset.order_by(*order_by).values_list('user_id', flat=True))
            if user.id in ordered_ids:
                me = {'rank': ordered_ids.index(user.id) + 1, 'value': getattr(mine, value_field)}
    return {'key': key, 'title': title, 'icon': icon, 'entries': entries, 'me': me}


def _star_boards(user):
    """星耀榜两张榜：星力榜（活跃奖励累计）与星富榜（当前余额）"""
    student_accounts = StarAccount.objects.filter(
        user__profile__role='student').select_related('user', 'user__profile', 'user__profile__class_obj')
    return [
        _build_board('force', '星力榜', '⚡', 'active_earned',
                     ('-active_earned', '-balance', 'user_id'),
                     student_accounts.filter(active_earned__gt=0), user),
        _build_board('wealth', '星富榜', '💰', 'balance',
                     ('-balance', '-active_earned', 'user_id'),
                     student_accounts.filter(balance__gt=0), user),
    ]


@login_required
def leaderboard(request):
    """星耀榜：星力榜（活跃奖励累计）与星富榜（当前余额）"""
    return render(request, 'starcoin/leaderboard.html', {
        'boards': _star_boards(request.user),
        'account': get_account(request.user),
    })


@login_required
def leaderboard_share(request):
    """星耀榜分享图：?board=force|wealth"""
    boards = _star_boards(request.user)
    board = next((b for b in boards if b['key'] == request.GET.get('board')), boards[0])
    rows = [{'rank': e['rank'], 'name': e['name'], 'sub': e['class_name'],
             'value': f"{e['value']} 星币"} for e in board['entries']]
    buffer = render_leaderboard_share_image(
        f"星耀榜 · {board['title']}",
        f"{timezone.localdate():%Y年%m月%d日} 星币排行 · 扫码一起来斩题赚星币",
        rows, share_site_url(request))
    star_hooks.on_leaderboard_shared(request.user)
    return leaderboard_share_response(buffer, f'starcoin_{board["key"]}.png')


# ===== 道具商城 =====

@login_required
def mall(request):
    """道具商城：上架道具列表 + 我的余额 + 会员折扣价。

    unit_price_coins 是按当前用户身份（会员 / 非会员）算出的单价，非数据库字段，
    仅供模板展示与「星币是否足够」判断使用，真实扣费一律由 services.redeem_item 重新计算。
    """
    is_member = is_member_active(request.user)
    items = []
    for item in StarItem.objects.filter(is_active=True).order_by('sort_order', 'id'):
        item.unit_price_coins = item.price_for_member(is_member)
        items.append(item)
    return render(request, 'starcoin/mall.html', {
        'items': items,
        'account': get_account(request.user),
        'is_member': is_member,
    })


@login_required
@require_POST
def redeem(request, item_id):
    """兑换道具（扣星币，生成待发放记录）"""
    item = get_object_or_404(StarItem, pk=item_id, is_active=True)
    try:
        redemption = redeem_item(
            request.user, item,
            quantity=request.POST.get('quantity', 1),
            contact=request.POST.get('contact', '').strip(),
            user_remark=request.POST.get('user_remark', '').strip(),
        )
    except StarCoinError as exc:
        messages.error(request, str(exc))
        return redirect('starcoin:mall')

    if redemption.is_discounted:
        messages.success(
            request,
            f'兑换成功！已享会员 {redemption.discount_label}，扣除 {redemption.coins_cost} 星币'
            f'（原价 {redemption.original_coins} 星币，省 {redemption.saved_coins} 星币），'
            f'奖品将由管理员核销发放。')
    else:
        messages.success(
            request, f'兑换成功！已扣除 {redemption.coins_cost} 星币，奖品将由管理员核销发放。')
    return redirect('starcoin:records')


# ===== 充值 =====

@login_required
def recharge(request):
    """星币充值套餐列表"""
    return render(request, 'starcoin/recharge.html', {
        'packages': StarPackage.objects.filter(is_active=True),
        'account': get_account(request.user),
    })


@login_required
def buy(request, package_id):
    """创建星币充值订单并进入支付页（金额与到账星币按套餐快照入单）"""
    package = get_object_or_404(StarPackage, pk=package_id, is_active=True)
    order = StarRechargeOrder.objects.create(
        user=request.user, package=package,
        amount=package.price, coins=package.total_coins)
    return redirect('starcoin:pay', order_no=order.order_no)


@login_required
def pay(request, order_no):
    """星币充值支付页"""
    order = get_object_or_404(StarRechargeOrder, order_no=order_no, user=request.user)

    if order.status == StarRechargeOrder.STATUS_PAID:
        return render(request, 'starcoin/result.html', {
            'order': order, 'success': True, 'message': '该订单已支付，星币已到账。',
        })

    # 兜底：进入支付页时主动查单确认（新订单跳过，避免无意义查询）
    if is_sync_due(order, settings.ORDER_SYNC_MIN_AGE_SECONDS):
        state, order = sync_order(order)
        if state == STATE_PAID:
            return render(request, 'starcoin/result.html', {
                'order': order, 'success': True, 'message': '支付成功，星币已到账。',
            })

    if order.is_expired:
        order.close()
        return render(request, 'starcoin/result.html', {
            'order': order, 'success': False,
            'message': f'订单超过 {settings.ORDER_TIMEOUT_MINUTES} 分钟未支付，已关闭，请重新下单。',
        })

    return render(request, 'starcoin/pay.html', {
        'order': order,
        'pay_url': build_pay_url(order, subject=f'星币充值-{order.package.name}'),
    })


def _split_sign_params(raw):
    """拆出待验签参数与签名值（必须用 raw.items()，QueryDict 的 dict() 会得到列表值）"""
    params = dict(raw.items())
    signature = params.pop('sign', '')
    return params, signature


def alipay_return(request):
    """同步跳转：验签后主动查单确认并到账"""
    params, signature = _split_sign_params(request.GET)
    order = StarRechargeOrder.objects.filter(order_no=params.get('out_trade_no', '')).first()

    if not signature:
        return render(request, 'starcoin/result.html', {
            'order': order, 'success': False, 'message': '缺少签名参数，无法确认支付结果。',
        })

    try:
        verified = get_alipay().verify(params, signature)
    except Exception:
        verified = False
    if not verified:
        return render(request, 'starcoin/result.html', {
            'order': order, 'success': False, 'message': '支付结果验签失败。',
        })
    if order is None:
        return render(request, 'starcoin/result.html', {
            'order': None, 'success': False, 'message': '未找到对应订单。',
        })

    state, order = sync_order(order)
    if state == STATE_PAID:
        success, message = True, '支付成功，星币已到账。'
    elif state == STATE_AMOUNT_MISMATCH:
        success, message = False, '支付金额与订单不一致，未到账，请联系客服。'
    else:
        success, message = False, '支付结果已确认，正在等待支付宝异步通知完成到账（可稍后刷新查看）。'

    return render(request, 'starcoin/result.html', {
        'order': order, 'success': success, 'message': message,
    })


@csrf_exempt
@require_POST
def alipay_notify(request):
    """异步通知：验签 -> 校验金额 -> 幂等到账"""
    params, signature = _split_sign_params(request.POST)
    if not signature:
        return HttpResponse('failure')

    try:
        verified = get_alipay().verify(params, signature)
    except Exception:
        verified = False
    if not verified:
        return HttpResponse('failure')

    if params.get('app_id') and params['app_id'] != settings.ALIPAY_APPID:
        return HttpResponse('failure')

    if params.get('trade_status') not in TRADE_SUCCESS_STATES:
        return HttpResponse('success')

    order_no = params.get('out_trade_no', '')
    # 星币订单号以 SC 前缀开头；若与本通知无关（如会员订单），直接确认停止重试
    if not order_no.startswith(StarRechargeOrder.ORDER_NO_PREFIX):
        return HttpResponse('success')

    order = StarRechargeOrder.objects.filter(order_no=order_no).first()
    if order is None:
        return HttpResponse('failure')
    if not amount_matches(order.amount, params.get('total_amount', '')):
        return HttpResponse('failure')

    mark_order_paid(order_no, params.get('trade_no', ''))
    return HttpResponse('success')


# ===== 我的记录 =====

@login_required
def records(request):
    """我的兑换记录与星币流水"""
    return render(request, 'starcoin/records.html', {
        'account': get_account(request.user),
        'redemptions': StarRedemption.objects.filter(
            user=request.user).select_related('item').order_by('-id')[:50],
        'transactions': StarTransaction.objects.filter(
            user=request.user).order_by('-id')[:50],
    })
