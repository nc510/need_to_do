# 本模块由 quiz/views.py 拆分生成（P2-1），公共依赖（import/类/常量/工具函数）见 views_common.py
from .views_common import *  # noqa: F401,F403

# 用户中心聚合统计缓存：成绩趋势 / 错题分布 / 薄弱知识点都是聚合扫描，
# 60 秒内重复进入用户中心直接复用。这类数据用 TTL 自然过期即可，
# 不做提交时失效——考试高峰期逐个提交去清缓存只会让缓存反复重建，得不偿失。
USER_CENTER_STATS_CACHE_KEY = 'user_center_stats:{}'
USER_CENTER_STATS_SECONDS = 60


def _user_center_stats(user):
    """用户中心的聚合统计（缓存 60 秒），返回：
    test_count / completed_count / wrong_count / trend / review_map / weak_kp
    """
    key = USER_CENTER_STATS_CACHE_KEY.format(user.pk)
    stats = cache.get(key)
    if stats is not None:
        return stats

    # 答题次数（合并为一次聚合查询）
    test_stats = TestRecord.objects.filter(user=user).aggregate(
        total=Count('id'),
        completed=Count('id', filter=Q(completed_at__isnull=False)),
    )
    # 错题复习状态分布
    review_map = {
        r['review_status']: r['cnt']
        for r in WrongQuestion.objects.filter(user=user)
            .values('review_status').annotate(cnt=Count('id'))
    }
    stats = {
        'test_count': test_stats['total'],
        'completed_count': test_stats['completed'],
        # 错题数量只统计当前错题本（已消除/已掌握的题归入历史，不计入）
        'wrong_count': WrongQuestion.objects.filter(user=user)
            .exclude(review_status='mastered').count(),
        # 成绩趋势（最近10次，按时间正序）
        'trend': list(TestRecord.objects.filter(
            user=user, completed_at__isnull=False
        ).order_by('completed_at').values('completed_at', 'score', 'total_score')[:10]),
        'review_map': review_map,
        # 薄弱知识点（当前错题本中错题最多的知识点 top5，已消除的不再计入）
        'weak_kp': [
            {'name': k['question__knowledge_points__name'], 'count': k['cnt']}
            for k in WrongQuestion.objects.filter(user=user)
                .exclude(review_status='mastered')
                .exclude(question__knowledge_points__isnull=True)
                .values('question__knowledge_points__name')
                .annotate(cnt=Count('id', distinct=True))
                .order_by('-cnt')[:5]
            if k['question__knowledge_points__name']
        ],
    }
    cache.set(key, stats, USER_CENTER_STATS_SECONDS)
    return stats


@login_required
def user_center(request):
    try:
        profile = Profile.objects.get(user=request.user)
    except Profile.DoesNotExist:
        profile = Profile.objects.create(user=request.user)

    stats = _user_center_stats(request.user)
    test_count = stats['test_count']
    completed_count = stats['completed_count']
    wrong_count = stats['wrong_count']

    # 正确率：与榜单同一口径（答对题次 / 实际作答题次，未作答的题不计入分母），
    # 直接读 Profile 冗余计数，保证与正确率榜显示的数值完全一致
    accuracy_rate = accuracy_percent(profile.answered_correct, profile.answered_total)

    recent_tests = TestRecord.objects.filter(user=request.user).order_by('-completed_at')[:5]
    recent_wrong_questions = WrongQuestion.objects.filter(
        user=request.user).exclude(review_status='mastered').order_by('-added_at')[:5]

    # ===== P2-1 学习数据可视化 =====
    # 成绩趋势（最近10次，按时间正序）：数据来自缓存，此处只做坐标换算
    trend_qs = stats['trend']
    trend_data = []
    for r in trend_qs:
        rate = round(r['score'] / r['total_score'] * 100, 1) if r['total_score'] else 0
        trend_data.append({'date': r['completed_at'].strftime('%m-%d'), 'rate': rate})
    # SVG 折线坐标（viewBox 320x140）
    W, H, PAD_X, PAD_Y = 320, 140, 24, 18
    n = len(trend_data)
    trend_points = []
    for i, d in enumerate(trend_data):
        x = PAD_X + (W - 2 * PAD_X) * (i / (n - 1)) if n > 1 else W / 2
        y = (H - PAD_Y) - (d['rate'] / 100) * (H - 2 * PAD_Y)
        trend_points.append({'x': round(x, 1), 'y': round(y, 1), 'rate': d['rate'], 'date': d['date']})
    polyline_str = ' '.join("{},".format(p['x']) + str(p['y']) for p in trend_points)
    # 折线下方面积多边形点串（闭合到基线 y=122）
    area_polygon = ''
    if len(trend_points) >= 2:
        area_polygon = polyline_str + " " + "{}".format(trend_points[-1]['x']) + ",122" + " " + "{}".format(trend_points[0]['x']) + ",122"

    # 错题复习状态分布（圆环图，对接 P1-2 复习状态机）：数据来自缓存
    review_map = stats['review_map']
    review_data = [
        {'label': '未复习', 'count': review_map.get('new', 0), 'color': '#95a5a6'},
        {'label': '复习中', 'count': review_map.get('reviewing', 0), 'color': '#f39c12'},
        {'label': '顽固错题', 'count': review_map.get('difficult', 0), 'color': '#e74c3c'},
        {'label': '已掌握', 'count': review_map.get('mastered', 0), 'color': '#27ae60'},
    ]
    review_total = sum(d['count'] for d in review_data)
    review_segments = []
    cum = 0.0
    for seg in review_data:
        if review_total == 0 or seg['count'] == 0:
            continue
        pct = seg['count'] / review_total * 100
        start = cum
        cum += pct
        review_segments.append({
            'color': seg['color'], 'start': round(start, 1), 'end': round(cum, 1),
            'label': seg['label'], 'count': seg['count'], 'pct': round(pct)
        })
    donut_gradient = ', '.join("{} {:.1f}% {:.1f}%".format(s['color'], s['start'], s['end']) for s in review_segments) if review_segments else '#ecf0f1 0% 100%'

    # 薄弱知识点（当前错题本中错题最多的知识点 top5，已消除的不再计入）：数据来自缓存
    weak_kp = stats['weak_kp']
    max_weak = weak_kp[0]['count'] if weak_kp else 1
    # ===== P2-1 END =====

    # ===== P2-2 教师工作台待办（班级管理员可见）=====
    teacher_todos = None
    admin_classes_qs = Class.objects.filter(class_admins__user=request.user).distinct()
    if admin_classes_qs.exists() or request.user.is_staff:
        pending_total = ClassApplication.objects.filter(class_obj__in=admin_classes_qs, status=0).count()
        published_assignments_count = ClassAssignment.objects.filter(class_obj__in=admin_classes_qs, status=1).count()
        teacher_todos = {
            'class_count': admin_classes_qs.count(),
            'pending_count': pending_total,
            'assignment_count': published_assignments_count,
        }
    # ===== P2-2 END =====

    # 星币账户（独立子系统，供用户中心展示余额与入口）
    from starcoin.services import get_account
    star_account = get_account(request.user)

    context = {
        'profile': profile,
        'star_account': star_account,
        'recent_tests': recent_tests,
        'recent_wrong_questions': recent_wrong_questions,
        'is_admin': request.user.is_staff,
        'test_count': test_count,
        'completed_count': completed_count,
        'wrong_count': wrong_count,
        'accuracy_rate': accuracy_rate,
        'trend_points': trend_points,
        'polyline_str': polyline_str,
        'area_polygon': area_polygon,
        'has_trend': len(trend_points) >= 2,
        'review_segments': review_segments,
        'review_total': review_total,
        'donut_gradient': donut_gradient,
        'weak_kp': weak_kp,
        'max_weak': max_weak,
        'teacher_todos': teacher_todos,
    }

    return render(request, 'quiz/frontend/user_center.html', context)




@login_required
def notification_list(request):
    """通知列表 + 标记单条已读（?read=N）"""
    read_id = request.GET.get('read')
    if read_id:
        Notification.objects.filter(id=read_id, recipient=request.user).update(is_read=True)
        # queryset.update 不触发信号，红点缓存需显式失效
        invalidate_unread_notifications(request.user.pk)
    notifications = Notification.objects.filter(recipient=request.user).select_related('sender')[:50]
    unread = Notification.objects.filter(recipient=request.user, is_read=False).count()
    return render(request, 'quiz/frontend/notifications.html', {
        'notifications': notifications,
        'unread_count': unread,
    })


@login_required
def notification_read_all(request):
    """全部标记已读"""
    if request.method == 'POST':
        Notification.objects.filter(recipient=request.user, is_read=False).update(is_read=True)
        # queryset.update 不触发信号，红点缓存需显式失效
        invalidate_unread_notifications(request.user.pk)
        messages.success(request, '已全部标记为已读 ✓')
    return redirect('notification_list')
