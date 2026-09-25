from django.conf import settings
from django.contrib.auth.decorators import login_required
from django.http import HttpResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

from quiz.models import Profile
from starcoin.models import StarRechargeOrder

from .alipay_client import build_pay_url, get_alipay
from .models import Order, Plan, RechargeConfig
from .services import (
    STATE_AMOUNT_MISMATCH,
    STATE_PAID,
    TRADE_SUCCESS_STATES,
    amount_matches,
    is_sync_due,
    mark_order_paid,
    sync_order,
)


def _split_sign_params(raw):
    """拆出待验签参数与签名值。

    必须用 raw.items()：QueryDict 的 dict() 会得到列表值，
    会让 trade_status/金额/app_id 等比较全部失效。
    """
    params = dict(raw.items())
    signature = params.pop('sign', '')
    return params, signature


def plans(request):
    """套餐列表"""
    profile = None
    if request.user.is_authenticated:
        profile = Profile.objects.filter(user=request.user).first()
    return render(request, 'membership/plans.html', {
        'plans': Plan.objects.filter(is_active=True),
        'profile': profile,
        'recharge_config': RechargeConfig.get_solo(),
    })


@login_required
def buy(request, plan_id):
    """创建订单并进入支付页（金额按当前充值折扣折算后快照入单）"""
    plan = get_object_or_404(Plan, pk=plan_id, is_active=True)
    order = Order.objects.create(
        user=request.user, plan=plan,
        amount=plan.final_price, discount_rate=plan.discount_rate)
    return redirect('membership:pay', order_no=order.order_no)


@login_required
def pay(request, order_no):
    """支付页：展示订单与支付宝跳转链接"""
    order = get_object_or_404(Order, order_no=order_no, user=request.user)

    if order.status == Order.STATUS_PAID:
        return render(request, 'membership/result.html', {
            'order': order, 'success': True, 'message': '该订单已支付，会员已生效。',
        })

    # 兜底：用户没有跟随后端回跳时，进入支付页先主动查单确认
    # 新订单（账龄不足 ORDER_SYNC_MIN_AGE_SECONDS）跳过，避免无意义的查询
    if is_sync_due(order):
        state, order = sync_order(order)
        if state == STATE_PAID:
            return render(request, 'membership/result.html', {
                'order': order, 'success': True, 'message': '支付成功，会员已生效。',
            })

    if order.is_expired:
        order.close()
        return render(request, 'membership/result.html', {
            'order': order, 'success': False, 'message': f'订单超过 {settings.ORDER_TIMEOUT_MINUTES} 分钟未支付，已关闭，请重新下单。',
        })

    return render(request, 'membership/pay.html', {'order': order, 'pay_url': build_pay_url(order)})


def alipay_return(request):
    """同步跳转：验签后主动查单确认支付结果，确认成功即履约。

    支付宝异步通知在部分网络环境下可能延迟或丢失，
    因此这里用 alipay.trade.query 主动确认，保证会员能正常开通。
    """
    params, signature = _split_sign_params(request.GET)
    order_no = params.get('out_trade_no', '')

    # 星币充值订单（SC 前缀）与会员订单共用同一套支付宝回调地址，按订单号前缀分流
    if order_no.startswith(StarRechargeOrder.ORDER_NO_PREFIX):
        from starcoin.views import alipay_return as starcoin_alipay_return
        return starcoin_alipay_return(request)

    order = Order.objects.filter(order_no=order_no).first()

    if not signature:
        return render(request, 'membership/result.html', {
            'order': order, 'success': False, 'message': '缺少签名参数，无法确认支付结果。',
        })

    try:
        verified = get_alipay().verify(params, signature)
    except Exception:
        verified = False

    if not verified:
        return render(request, 'membership/result.html', {
            'order': order, 'success': False, 'message': '支付结果验签失败。',
        })

    if order is None:
        return render(request, 'membership/result.html', {
            'order': None, 'success': False, 'message': '未找到对应订单。',
        })

    state, order = sync_order(order)
    if state == STATE_PAID:
        success, message = True, '支付成功，会员已生效。'
    elif state == STATE_AMOUNT_MISMATCH:
        success, message = False, '支付金额与订单不一致，未开通会员，请联系客服。'
    else:
        # 未支付成功或查单失败：交给异步通知重试/用户稍后刷新
        success, message = False, '支付结果已确认，正在等待支付宝异步通知完成开通（可稍后刷新查看）。'

    return render(request, 'membership/result.html', {
        'order': order, 'success': success, 'message': message,
    })


@csrf_exempt
@require_POST
def alipay_notify(request):
    """异步通知：验签 -> 校验金额 -> 幂等履约。"""
    params, signature = _split_sign_params(request.POST)
    order_no = params.get('out_trade_no', '')

    # 星币充值订单按前缀分流到星币侧完成验签与履约（两套订单共用同一通知地址）
    if order_no.startswith(StarRechargeOrder.ORDER_NO_PREFIX):
        from starcoin.views import alipay_notify as starcoin_alipay_notify
        return starcoin_alipay_notify(request)

    if not signature:
        return HttpResponse('failure')

    try:
        verified = get_alipay().verify(params, signature)
    except Exception:
        verified = False
    if not verified:
        return HttpResponse('failure')

    # 确认通知来自本应用
    if params.get('app_id') and params['app_id'] != settings.ALIPAY_APPID:
        return HttpResponse('failure')

    # 非成功状态无需履约，但仍需返回 success 停止重试
    if params.get('trade_status') not in TRADE_SUCCESS_STATES:
        return HttpResponse('success')

    order_no = params.get('out_trade_no', '')
    order = Order.objects.filter(order_no=order_no).first()
    if order is None:
        return HttpResponse('failure')

    # 金额校验：以订单快照金额为准
    if not amount_matches(order.amount, params.get('total_amount', '')):
        return HttpResponse('failure')

    # 幂等：重复通知直接确认，不重复延长会员
    mark_order_paid(order_no, params.get('trade_no', ''))

    return HttpResponse('success')
