"""模板 context processor：注入未读通知数、系统公告到所有模板"""
from django.core.cache import cache

from quiz.models import (
    ANNOUNCEMENTS_CACHE_KEY, UNREAD_NOTIFICATIONS_CACHE_KEY,
    Announcement, Notification,
)


def unread_notifications(request):
    """注入 unread_notifications 到所有模板 context，供导航栏🔔红点使用。

    每个页面渲染都要读，故按用户缓存 60 秒；通知的新增/已读/删除都会即时失效
    （见 models.invalidate_unread_notifications），红点不会滞后。
    """
    user = getattr(request, 'user', None)
    if user is None or not user.is_authenticated:
        return {'unread_notifications': 0}
    key = UNREAD_NOTIFICATIONS_CACHE_KEY.format(user.pk)
    count = cache.get(key)
    if count is None:
        try:
            count = Notification.objects.filter(recipient=user, is_read=False).count()
        except Exception:
            count = 0
        cache.set(key, count, 60)
    return {'unread_notifications': count}


def site_announcements(request):
    """注入 site_announcements（滚动条 / 公告板两组）到所有模板 context。

    公告变动不频繁但每次渲染都要读，故走缓存；增删改由模型信号即时失效。
    缓存 TTL 取 60 秒，保证「生效/失效时间」到点后最多 1 分钟自动切换。
    """
    try:
        data = cache.get(ANNOUNCEMENTS_CACHE_KEY)
        if data is None:
            items = list(Announcement.active_now())
            data = {
                'scroll': [a for a in items if a.display_mode == Announcement.MODE_SCROLL],
                'static': [a for a in items if a.display_mode == Announcement.MODE_STATIC],
            }
            cache.set(ANNOUNCEMENTS_CACHE_KEY, data, 60)
    except Exception:
        # 公告表尚未迁移等异常不应影响页面渲染
        data = {'scroll': [], 'static': []}
    return {'site_announcements': data}
