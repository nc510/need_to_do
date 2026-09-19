# ==============================================================================
# 反爬虫中间件
# ==============================================================================

import time
import hashlib
import hmac
import secrets
from django.http import HttpResponseForbidden, HttpResponse
from django.conf import settings
from django.core.cache import cache
from django.utils import timezone

# 配置常量
RATE_LIMITS = {
    # (路径模式, 时间窗口(秒), 最大请求数)
    ('/quiz/login/', 60, 20),           # 登录页面：1分钟最多20次
    ('/quiz/register/', 60, 10),        # 注册页面：1分钟最多10次
    ('/quiz/create_test_paper/', 300, 10),  # 创建试卷：5分钟最多10次
    ('/quiz/submit/', 60, 30),         # 提交答题：1分钟最多30次
    ('/quiz/', 60, 100),                # 其他quiz路径：1分钟最多100次
}

# 不参与限流的路径：验证码图片接口本身无业务副作用，
# 且机房/校园网共用同一出口 IP，高频刷新会被误伤成 403，
# 导致图片加载失败而验证码必然校验不通过
RATE_LIMIT_EXCLUDE = (
    '/quiz/captcha/',
)

# 可疑的User-Agent列表
SUSPICIOUS_USER_AGENTS = [
    'bot', 'spider', 'crawler', 'scrapy', 'curl', 'wget',
    'python-requests', 'httpie', 'phantomjs', 'selenium',
    'headless', 'chromedriver', 'geckodriver'
]

# 在线活跃度：同一用户在该秒数内只写一次 last_seen_at，避免每请求一次数据库写入
ACTIVITY_THROTTLE_SECONDS = 60
# 后台「在线用户」判定窗口（秒）：最后活动时间在该窗口内即视为在线
ONLINE_WINDOW_SECONDS = 300

# IP白名单（从 settings 读取，支持 .env 覆盖）
IP_WHITELIST = getattr(settings, 'ANTISPIDER_IP_WHITELIST', ['127.0.0.1', '::1'])


def get_client_ip(request):
    """获取客户端真实IP"""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0].strip()
    elif request.META.get('HTTP_X_REAL_IP'):
        ip = request.META.get('HTTP_X_REAL_IP')
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


def is_suspicious_user_agent(user_agent):
    """检查User-Agent是否可疑。空 UA 不拦截（避免误伤隐私浏览器）"""
    if not user_agent:
        return False
    ua_lower = user_agent.lower()
    for suspicious in SUSPICIOUS_USER_AGENTS:
        if suspicious in ua_lower:
            return True
    return False


def check_rate_limit(ip, path):
    """检查请求频率限制。
    首次用 cache.add 设置 TTL，后续 cache.incr 不重置 TTL。
    原实现 cache.set 每次重置 TTL，持续请求会无限续期，限流永不过期。
    """
    if path.startswith(RATE_LIMIT_EXCLUDE):
        return True, None

    for pattern, window, max_requests in RATE_LIMITS:
        if path.startswith(pattern):
            key = f"ratelimit:{ip}:{pattern}"
            requests = cache.get(key)
            if requests is None:
                # 首次访问：初始化计数为 1 并设置 TTL（window 秒后自动过期）
                cache.add(key, 1, window)
            else:
                if requests >= max_requests:
                    return False, f"请求过于频繁，请 {window} 秒后重试"
                # incr 不重置 TTL（保持首次设置的过期时间）
                try:
                    cache.incr(key)
                except ValueError:
                    # key 在 get 与 incr 之间过期，重新初始化
                    cache.add(key, 1, window)
            break

    return True, None


class AntiSpiderMiddleware:
    """反爬虫中间件"""
    
    def __init__(self, get_response):
        self.get_response = get_response
    
    def __call__(self, request):
        # 获取客户端IP
        client_ip = get_client_ip(request)
        user_agent = request.META.get('HTTP_USER_AGENT', '')
        path = request.path
        
        # IP白名单跳过检查
        if client_ip in IP_WHITELIST:
            return self.get_response(request)
        
        # 检查User-Agent
        if is_suspicious_user_agent(user_agent):
            return HttpResponseForbidden(
                '<h1>403 Forbidden</h1><p>访问被拒绝：检测到异常请求</p>'
            )
        
        # 检查请求频率
        allowed, message = check_rate_limit(client_ip, path)
        if not allowed:
            return HttpResponseForbidden(f'<h1>403 Forbidden</h1><p>{message}</p>')
        
        # 检查Cookie（简单的人机验证）
        if not self.has_valid_cookie(request):
            # 如果是第一次访问，设置验证Cookie
            if not request.COOKIES.get('__anti_spider__'):
                response = self.get_response(request)
                response.set_cookie('__anti_spider__', self.generate_cookie_value(), max_age=86400)
                return response
        
        return self.get_response(request)
    
    def _sign_cookie(self, nonce):
        """用 SECRET_KEY 对 nonce 做 HMAC 签名，防止 cookie 伪造"""
        return hmac.new(settings.SECRET_KEY.encode(), nonce.encode(), hashlib.md5).hexdigest()

    def has_valid_cookie(self, request):
        """检查 cookie 是否有效（签名校验，防止伪造；原仅校验长度易被绕过）"""
        cookie_value = request.COOKIES.get('__anti_spider__')
        if not cookie_value or '.' not in cookie_value:
            return False
        nonce, sig = cookie_value.split('.', 1)
        expected_sig = self._sign_cookie(nonce)
        return secrets.compare_digest(sig, expected_sig)

    def generate_cookie_value(self):
        """生成带签名的验证 cookie：nonce.signature"""
        nonce = secrets.token_hex(16)
        sig = self._sign_cookie(nonce)
        return f"{nonce}.{sig}"


class OnlineActivityMiddleware:
    """记录已登录用户的最后活动时间，供后台「在线用户」统计使用。

    仅维护 Profile.last_seen_at，不做任何访问限制；
    借助缓存做 60 秒节流（同一用户每分钟最多一次 UPDATE），避免每请求写库。
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        self.mark_activity(request)
        return self.get_response(request)

    def mark_activity(self, request):
        user = getattr(request, 'user', None)
        if user is None or not user.is_authenticated:
            return
        # cache.add 成功说明距上次写入已超过节流窗口，失败则直接跳过本次写库
        if not cache.add(f'activity:{user.pk}', 1, ACTIVITY_THROTTLE_SECONDS):
            return
        from .models import Profile
        try:
            Profile.objects.filter(user_id=user.pk).update(last_seen_at=timezone.now())
        except Exception:
            # 活跃度记录属于附加统计，失败不能影响正常请求
            pass