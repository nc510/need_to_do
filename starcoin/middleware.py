"""每日登录赠礼补发中间件。

赠礼原先只挂在「登录」动作上，登录后长期不退出登录的用户当天拿不到。
这里在页面访问时补一次：按本地自然日判定 + session 标记节流，
发放本身由 services.grant_login_gift 保证幂等，登录时已发过的不会重复发。
"""

import logging

from django.contrib import messages

from . import hooks as star_hooks

logger = logging.getLogger(__name__)


class DailyGiftMiddleware:
    """已登录用户当天首次访问页面时补发每日登录赠礼，并在页面上给出提示。"""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        self.ensure_daily_gift(request)
        return self.get_response(request)

    def ensure_daily_gift(self, request):
        # 只处理普通页面 GET：后台、接口回调、AJAX 都不在此处弹赠礼提示
        if request.method != 'GET' or request.path.startswith('/admin/'):
            return
        if request.headers.get('x-requested-with') == 'XMLHttpRequest':
            return
        try:
            gift_message = star_hooks.on_page_view(request)
        except Exception:
            # 赠礼属于附加福利，任何异常都不能影响页面正常渲染
            logger.exception('每日登录赠礼补发异常')
            return
        if gift_message:
            messages.success(request, gift_message)
