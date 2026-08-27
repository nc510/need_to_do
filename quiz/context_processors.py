"""模板 context processor：注入未读通知数到所有模板"""
from quiz.models import Notification


def unread_notifications(request):
    """注入 unread_notifications 到所有模板 context，供导航栏🔔红点使用"""
    if getattr(request, 'user', None) is not None and request.user.is_authenticated:
        try:
            count = Notification.objects.filter(
                recipient=request.user, is_read=False
            ).count()
        except Exception:
            count = 0
        return {'unread_notifications': count}
    return {'unread_notifications': 0}
