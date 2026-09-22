"""支付宝客户端封装。"""

from functools import lru_cache

from alipay import AliPay
from django.conf import settings

# SDK 内部默认沙箱网关会随版本变化，这里显式给出，避免被动切换
SANDBOX_GATEWAY = 'https://openapi-sandbox.dl.alipaydev.com/gateway.do'
PRODUCTION_GATEWAY = 'https://openapi.alipay.com/gateway.do'


def _read_key(path):
    with open(path, 'r', encoding='utf-8') as fp:
        return fp.read()


@lru_cache(maxsize=1)
def get_alipay():
    """初始化 AliPay 实例（RSA2 签名）。"""
    if not settings.ALIPAY_APPID:
        raise RuntimeError('ALIPAY_APPID 未配置，请在 .env 中填写 APPID')

    alipay = AliPay(
        appid=settings.ALIPAY_APPID,
        app_notify_url=settings.ALIPAY_NOTIFY_URL or None,
        app_private_key_string=_read_key(settings.ALIPAY_PRIVATE_KEY_PATH),
        alipay_public_key_string=_read_key(settings.ALIPAY_PUBLIC_KEY_PATH),
        sign_type='RSA2',
        debug=settings.ALIPAY_SANDBOX,
    )
    # 显式指定网关：留空则按沙箱开关取默认值
    alipay._gateway = settings.ALIPAY_GATEWAY or (
        SANDBOX_GATEWAY if settings.ALIPAY_SANDBOX else PRODUCTION_GATEWAY
    )
    return alipay


def get_gateway():
    """当前使用的网关地址。"""
    return get_alipay()._gateway


def build_pay_url(order, subject=None):
    """由订单生成电脑网站支付跳转链接。"""
    alipay = get_alipay()
    order_string = alipay.api_alipay_trade_page_pay(
        out_trade_no=order.order_no,
        total_amount=str(order.amount),
        subject=subject or f'会员充值-{order.plan.name}',
        return_url=settings.ALIPAY_RETURN_URL or None,
        notify_url=settings.ALIPAY_NOTIFY_URL or None,
    )
    return f'{get_gateway()}?{order_string}'


def query_trade(order_no):
    """主动查单，返回支付宝响应字典。

    code == '10000' 表示查询成功，交易信息在返回字典里
    （trade_status / total_amount / trade_no）；
    交易不存在时返回 code=40004、sub_code=ACQ.TRADE_NOT_EXIST，不抛异常；
    网络异常会抛异常，需要调用方处理。
    """
    return get_alipay().api_alipay_trade_query(out_trade_no=order_no)
