# 本模块由 quiz/views.py 拆分生成（P2-1），公共依赖（import/类/常量/工具函数）见 views_common.py
from .views_common import *  # noqa: F401,F403

@login_required
def user_center(request):
    try:
        profile = Profile.objects.get(user=request.user)
    except Profile.DoesNotExist:
        profile = Profile.objects.create(user=request.user)
    
    # 获取统计数据（合并为聚合查询，原 5 次独立 count）
    test_stats = TestRecord.objects.filter(user=request.user).aggregate(
        total=Count('id'),
        completed=Count('id', filter=Q(completed_at__isnull=False)),
    )
    test_count = test_stats['total']
    completed_count = test_stats['completed']
    wrong_count = WrongQuestion.objects.filter(user=request.user).count()

    # 计算正确率（合并为 1 次聚合）
    answer_stats = AnswerRecord.objects.filter(test_record__user=request.user).aggregate(
        total=Count('id'),
        correct=Count('id', filter=Q(is_correct=True)),
    )
    total_answered = answer_stats['total']
    correct_answered = answer_stats['correct']
    accuracy_rate = int((correct_answered / total_answered) * 100) if total_answered > 0 else 0
    
    recent_tests = TestRecord.objects.filter(user=request.user).order_by('-completed_at')[:5]
    recent_wrong_questions = WrongQuestion.objects.filter(user=request.user).order_by('-added_at')[:5]

    # ===== P2-1 学习数据可视化 =====
    # 成绩趋势（最近10次，按时间正序）
    trend_qs = list(TestRecord.objects.filter(
        user=request.user, completed_at__isnull=False
    ).order_by('completed_at').values('completed_at', 'score', 'total_score')[:10])
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

    # 错题复习状态分布（圆环图，对接 P1-2 复习状态机）
    review_breakdown = WrongQuestion.objects.filter(user=request.user).values('review_status').annotate(cnt=Count('id'))
    review_map = {r['review_status']: r['cnt'] for r in review_breakdown}
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

    # 薄弱知识点（错题最多的知识点 top5）
    weak_kp = list(WrongQuestion.objects.filter(user=request.user)
        .exclude(question__knowledge_points__isnull=True)
        .values('question__knowledge_points__name')
        .annotate(cnt=Count('id', distinct=True))
        .order_by('-cnt')[:5])
    weak_kp = [{'name': k['question__knowledge_points__name'], 'count': k['cnt']}
               for k in weak_kp if k['question__knowledge_points__name']]
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

    context = {
        'profile': profile,
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
        messages.success(request, '已全部标记为已读 ✓')
    return redirect('notification_list')
