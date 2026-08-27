# 本模块由 quiz/views.py 拆分生成（P2-1），公共依赖（import/类/常量/工具函数）见 views_common.py
from .views_common import *  # noqa: F401,F403
import traceback

@login_required
def class_list(request):
    user_classes = Class.objects.filter(
        class_admins__user=request.user
    ).distinct().order_by('-created_at')
    
    student_classes = Class.objects.filter(
        profiles__user=request.user
    ).exclude(
        id__in=user_classes.values_list('id', flat=True)
    ).distinct()
    
    all_classes = (list(user_classes) + list(student_classes))
    unique_classes = []
    seen_ids = set()
    for cls in all_classes:
        if cls.id not in seen_ids:
            unique_classes.append(cls)
            seen_ids.add(cls.id)
    
    return render(request, 'quiz/frontend/class_list.html', {
        'classes': unique_classes
    })

@login_required
def class_detail(request, class_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    
    if not is_admin:
        is_student = Class.objects.filter(id=class_id, profiles__user=request.user).exists()
        if not is_student:
            messages.error(request, '您不是该班级的管理员或学生')
            return redirect('class_list')
    
    admins = ClassAdmin.objects.filter(class_obj=class_obj).select_related('user', 'user__profile')
    students = Profile.objects.filter(class_obj=class_obj, approval_status=1).select_related('user', 'user__profile')
    pending_applications = ClassApplication.objects.filter(class_obj=class_obj, status=0).select_related('user')

    # ===== P2-2 班级数据看板（仅管理员可见，annotate 避免 N+1）=====
    class_stats = None
    assignment_progress = []
    if is_admin:
        from django.db.models import Count as _Count, Q as _Q, Sum as _Sum
        student_count = students.count()
        # 已发布作业 + 每个作业提交人数（一次 annotate 查询）
        published_assignments = (ClassAssignment.objects.filter(class_obj=class_obj, status=1)
            .annotate(submitted_count=_Count('records', filter=_Q(records__is_submitted=True)))
            .select_related('test_paper')
            .order_by('-published_at')[:8])
        for a in published_assignments:
            rate = round(a.submitted_count / student_count * 100) if student_count else 0
            assignment_progress.append({
                'assignment': a,
                'submitted': a.submitted_count,
                'total': student_count,
                'rate': rate,
            })
        # 班级平均得分率 = 已提交记录得分总和 / 试卷总分总和
        submitted = ClassAssignmentRecord.objects.filter(
            assignment__class_obj=class_obj, is_submitted=True, score__isnull=False
        )
        agg = submitted.aggregate(sum_score=_Sum('score'), sum_total=_Sum('assignment__test_paper__total_score'))
        class_avg_rate = round(agg['sum_score'] / agg['sum_total'] * 100, 1) if agg['sum_total'] else 0
        class_stats = {
            'student_count': student_count,
            'assignment_count': ClassAssignment.objects.filter(class_obj=class_obj).count(),
            'published_count': ClassAssignment.objects.filter(class_obj=class_obj, status=1).count(),
            'avg_rate': class_avg_rate,
        }
    # ===== P2-2 END =====

    return render(request, 'quiz/frontend/class_detail.html', {
        'class_obj': class_obj,
        'admins': admins,
        'students': students,
        'pending_applications': pending_applications,
        'pending_count': pending_applications.count(),
        'is_admin': is_admin,
        'class_stats': class_stats,
        'assignment_progress': assignment_progress,
    })

@login_required
def create_class(request):
    if request.method == 'POST':
        name = request.POST.get('name', '').strip()
        description = request.POST.get('description', '').strip()
        code = request.POST.get('code', '').strip()
        join_rule = request.POST.get('join_rule', 'approval').strip()
        
        if not name or not code:
            messages.error(request, '请填写班级名称和班级代码')
            return render(request, 'quiz/frontend/create_class.html')
        
        if Class.objects.filter(code=code).exists():
            messages.error(request, '班级代码已存在')
            return render(request, 'quiz/frontend/create_class.html')
        
        class_obj = Class.objects.create(
            name=name,
            description=description,
            code=code,
            join_rule=join_rule
        )
        
        ClassAdmin.objects.create(
            class_obj=class_obj,
            user=request.user
        )
        
        try:
            profile = Profile.objects.get(user=request.user)
            profile.class_obj = class_obj
            profile.save()
        except Profile.DoesNotExist:
            Profile.objects.create(user=request.user, class_obj=class_obj)
        
        messages.success(request, f'班级 "{name}" 创建成功！')
        return redirect('class_detail', class_id=class_obj.id)
    
    return render(request, 'quiz/frontend/create_class.html')

@login_required
def edit_class(request, class_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能编辑班级信息')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        class_obj.name = request.POST.get('name', '').strip()
        class_obj.description = request.POST.get('description', '').strip()
        join_rule = request.POST.get('join_rule', 'approval').strip()
        class_obj.join_rule = join_rule
        class_obj.save()
        messages.success(request, '班级信息已更新')
        return redirect('class_detail', class_id=class_id)
    
    return render(request, 'quiz/frontend/edit_class.html', {'class_obj': class_obj})

@login_required
def delete_class(request, class_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能删除班级')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        class_obj.delete()
        messages.success(request, '班级已删除')
        return redirect('class_list')
    
    return render(request, 'quiz/frontend/delete_class.html', {'class_obj': class_obj})

@login_required
def add_class_admin(request, class_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能添加管理员')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        try:
            user = User.objects.get(username=username)
            if ClassAdmin.objects.filter(class_obj=class_obj, user=user).exists():
                messages.error(request, f'用户 {username} 已经是该班级的管理员')
            else:
                ClassAdmin.objects.create(class_obj=class_obj, user=user)
                messages.success(request, f'用户 {username} 已成为该班级的管理员')
        except User.DoesNotExist:
            messages.error(request, f'用户 {username} 不存在')
    
    return render(request, 'quiz/frontend/add_class_admin.html', {'class_obj': class_obj})

@login_required
def remove_class_admin(request, class_id, admin_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能移除管理员')
        return redirect('class_detail', class_id=class_id)
    
    admin = get_object_or_404(ClassAdmin, pk=admin_id, class_obj=class_obj)
    
    if request.method == 'POST':
        if admin.user == request.user:
            messages.error(request, '不能移除自己')
            return redirect('class_detail', class_id=class_id)
        
        admin.delete()
        messages.success(request, '已移除该管理员')
        return redirect('class_detail', class_id=class_id)
    
    return render(request, 'quiz/frontend/remove_class_admin.html', {
        'class_obj': class_obj,
        'admin': admin
    })

@login_required
def assign_student(request, class_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能分配学生')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        try:
            user = User.objects.get(username=username)
            
            if Class.objects.filter(id=class_id, profiles__user=user).exists():
                messages.error(request, f'用户 {username} 已经在该班级中')
            else:
                try:
                    profile = Profile.objects.get(user=user)
                    profile.class_obj = class_obj
                    profile.approval_status = 1
                    profile.save()
                except Profile.DoesNotExist:
                    Profile.objects.create(user=user, class_obj=class_obj, approval_status=1)
                
                ClassApplication.objects.filter(user=user, class_obj=class_obj).update(status=1)
                
                messages.success(request, f'用户 {username} 已添加到该班级')
        except User.DoesNotExist:
            messages.error(request, f'用户 {username} 不存在')
    
    return render(request, 'quiz/frontend/assign_student.html', {'class_obj': class_obj})

@login_required
def remove_student(request, class_id, user_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能移除学生')
        return redirect('class_detail', class_id=class_id)
    
    student = get_object_or_404(User, pk=user_id)
    
    if request.method == 'POST':
        try:
            profile = Profile.objects.get(user=student)
            profile.class_obj = None
            profile.save()
        except Profile.DoesNotExist:
            pass
        
        messages.success(request, f'学生 {student.username} 已从班级移除')
        return redirect('class_detail', class_id=class_id)
    
    return render(request, 'quiz/frontend/remove_student.html', {
        'class_obj': class_obj,
        'student': student
    })

@login_required
def apply_to_class(request):
    """申请加入班级（需登录，防止匿名用户提交）"""
    if request.method == 'POST':
        class_code = request.POST.get('class_code', '').strip()
        
        if not class_code:
            messages.error(request, '请输入班级代码')
            return render(request, 'quiz/frontend/apply_to_class.html')
        
        try:
            class_obj = Class.objects.get(code=class_code)
        except Class.DoesNotExist:
            messages.error(request, '班级代码不存在')
            return render(request, 'quiz/frontend/apply_to_class.html')
        
        if ClassApplication.objects.filter(user=request.user, class_obj=class_obj, status=0).exists():
            messages.error(request, '您已经申请过该班级，请等待审核')
            return render(request, 'quiz/frontend/apply_to_class.html')
        
        # 检查是否已经在班级中
        try:
            profile = Profile.objects.get(user=request.user)
            if profile.class_obj == class_obj:
                messages.error(request, '您已经在该班级中')
                return render(request, 'quiz/frontend/apply_to_class.html')
        except Profile.DoesNotExist:
            pass
        
        # 根据进班规则处理申请
        if class_obj.join_rule == 'auto':
            # 自动进班
            application = ClassApplication.objects.create(
                class_obj=class_obj,
                user=request.user,
                message=request.POST.get('message', ''),
                status=1
            )
            
            try:
                profile = Profile.objects.get(user=request.user)
                profile.class_obj = class_obj
                profile.approval_status = 1
                profile.save()
            except Profile.DoesNotExist:
                Profile.objects.create(user=request.user, class_obj=class_obj, approval_status=1)
            
            messages.success(request, f'已成功加入班级 "{class_obj.name}"！')
            return redirect('user_center')
        else:
            # 需要审核
            ClassApplication.objects.create(
                class_obj=class_obj,
                user=request.user,
                message=request.POST.get('message', '')
            )
            
            # 通知班级管理员有新申请
            Notification.notify_many(
                recipients=class_obj.get_admin_users(),
                sender=request.user,
                ntype='approval',
                title=f'新申请：{request.user.username} 申请加入 {class_obj.name}',
                content=f'{request.user.username} 申请加入班级「{class_obj.name}」，请前往班级管理审核。',
                link=f'/quiz/class/{class_obj.id}/applications/'
            )
            messages.success(request, f'已成功申请加入班级 "{class_obj.name}"，请等待管理员审核')
            return redirect('user_center')
    
    return render(request, 'quiz/frontend/apply_to_class.html')

@login_required
def my_applications(request):
    applications = ClassApplication.objects.filter(user=request.user).select_related('class_obj').order_by('-created_at')
    
    for app in applications:
        app.status_text = {0: '待审核', 1: '已通过', 2: '已拒绝'}.get(app.status, '未知')
    
    return render(request, 'quiz/frontend/my_applications.html', {
        'applications': applications
    })

@login_required
def class_applications(request, class_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能查看申请列表')
        return redirect('class_detail', class_id=class_id)
    
    pending_applications = ClassApplication.objects.filter(class_obj=class_obj, status=0).select_related('user')
    processed_applications = ClassApplication.objects.filter(
        class_obj=class_obj,
        status__in=[1, 2]
    ).select_related('user', 'reviewed_by').order_by('-reviewed_at')[:20]
    
    return render(request, 'quiz/frontend/class_applications.html', {
        'class_obj': class_obj,
        'pending_applications': pending_applications,
        'processed_applications': processed_applications
    })

@login_required
def approve_application(request, class_id, application_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能审批申请')
        return redirect('class_detail', class_id=class_id)
    
    application = get_object_or_404(ClassApplication, pk=application_id, class_obj=class_obj)
    
    application.status = 1
    application.reviewed_by = request.user
    application.save()
    
    try:
        profile = Profile.objects.get(user=application.user)
        profile.class_obj = class_obj
        profile.approval_status = 1
        profile.save()
    except Profile.DoesNotExist:
        Profile.objects.create(user=application.user, class_obj=class_obj, approval_status=1)
    
    # 通知申请学生审核通过
    Notification.notify(
        recipient=application.user,
        sender=request.user,
        ntype='approval',
        title=f'申请通过：已加入 {class_obj.name}',
        content=f'管理员已批准您加入班级「{class_obj.name}」的申请，欢迎加入！',
        link=f'/quiz/class/{class_id}/'
    )
    messages.success(request, f'已批准 {application.user.username} 的加入申请')
    return redirect('class_applications', class_id=class_id)

@login_required
def reject_application(request, class_id, application_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能审批申请')
        return redirect('class_detail', class_id=class_id)
    
    application = get_object_or_404(ClassApplication, pk=application_id, class_obj=class_obj)
    
    if request.method == 'POST':
        application.status = 2
        application.reviewed_by = request.user
        application.save()
        # 通知申请学生申请被拒绝
        Notification.notify(
            recipient=application.user,
            sender=request.user,
            ntype='approval',
            title=f'申请未通过：{class_obj.name}',
            content=f'很遗憾，您加入班级「{class_obj.name}」的申请未通过审核。如有疑问请联系管理员。',
            link='/quiz/my_applications/'
        )
        messages.success(request, f'已拒绝 {application.user.username} 的加入申请')
        return redirect('class_applications', class_id=class_id)
    
    return render(request, 'quiz/frontend/reject_application.html', {
        'class_obj': class_obj,
        'application': application
    })

@login_required
def class_assignments(request, class_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能查看作业')
        return redirect('class_detail', class_id=class_id)
    
    assignments = ClassAssignment.objects.filter(class_obj=class_obj).order_by('-created_at')
    
    return render(request, 'quiz/frontend/class_assignments.html', {
        'class_obj': class_obj,
        'assignments': assignments
    })

@login_required
def create_class_assignment(request, class_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能创建作业')
        return redirect('class_detail', class_id=class_id)
    
    # 获取已发布的试卷 或 自己创建的试卷（未发布也可用）
    available_papers = TestPaper.objects.filter(
        models.Q(is_published=True) | models.Q(created_by=request.user.username)
    )
    # 供模板"搜索框快捷选试卷"使用：序列化为轻量列表注入 json_script
    papers_list = [{
        'id': p.id,
        'title': p.title,
        'score': p.total_score,
        'published': p.is_published,
        'mine': p.created_by == request.user.username,
    } for p in available_papers]
    
    if request.method == 'POST':
        title = request.POST.get('title', '').strip()
        description = request.POST.get('description', '').strip()
        assignment_type = request.POST.get('type', '1')
        paper_id = request.POST.get('paper_id')
        deadline = request.POST.get('deadline')
        time_limit = request.POST.get('time_limit')
        
        if not title:
            messages.error(request, '请填写作业标题')
            return render(request, 'quiz/frontend/create_class_assignment.html', {
                'class_obj': class_obj,
                'available_papers': available_papers,
                'papers_list': papers_list,
            })
        
        if not paper_id:
            messages.error(request, '请选择试卷')
            return render(request, 'quiz/frontend/create_class_assignment.html', {
                'class_obj': class_obj,
                'available_papers': available_papers,
                'papers_list': papers_list,
            })

        if not deadline:
            messages.error(request, '请填写截止时间')
            return render(request, 'quiz/frontend/create_class_assignment.html', {
                'class_obj': class_obj,
                'available_papers': available_papers,
                'papers_list': papers_list,
            })

        assignment_type_int = int(assignment_type)
        assignment = ClassAssignment.objects.create(
            class_obj=class_obj,
            title=title,
            description=description,
            type=assignment_type_int,
            deadline=parse_datetime_local(deadline) if deadline else None,
            time_limit=int(time_limit) if (time_limit and assignment_type_int == 2) else None,
            test_paper=TestPaper.objects.get(id=paper_id),
            is_allow_exam=True
        )
        
        messages.success(request, f'{"考试" if assignment_type_int == 2 else "作业"} "{title}" 创建成功！')
        return redirect('class_assignments', class_id=class_id)
    
    return render(request, 'quiz/frontend/create_class_assignment.html', {
        'class_obj': class_obj,
        'available_papers': available_papers,
        'papers_list': papers_list,
    })

@login_required
def class_assignment_detail(request, class_id, assignment_id):
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id, class_obj_id=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=assignment.class_obj, user=request.user).exists()
    
    records = ClassAssignmentRecord.objects.filter(assignment=assignment).select_related('user')
    
    total_students = assignment.get_total_students()
    completed_count = assignment.get_completed_count()
    not_submitted_count = total_students - completed_count
    
    return render(request, 'quiz/frontend/class_assignment_detail.html', {
        'assignment': assignment,
        'class_obj': assignment.class_obj,
        'records': records,
        'is_admin': is_admin,
        'total_students': total_students,
        'completed_count': completed_count,
        'not_submitted_count': not_submitted_count
    })

@login_required
def publish_class_assignment(request, class_id, assignment_id):
    class_obj = get_object_or_404(Class, pk=class_id)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能发布作业')
        return redirect('class_detail', class_id=class_id)
    
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id, class_obj=class_obj)
    
    if request.method == 'POST':
        assignment.status = 1
        assignment.published_at = timezone.now()
        assignment.save()
        
        students = list(Profile.objects.filter(
            class_obj=class_obj, approval_status=1
        ).select_related('user'))
        # P1-5：避免 N 次 get_or_create，改为批量补建缺失记录（2 次查询 + 1 次 bulk_create）
        student_user_ids = [s.user_id for s in students]
        existing_user_ids = set(ClassAssignmentRecord.objects.filter(
            assignment=assignment, user_id__in=student_user_ids
        ).values_list('user_id', flat=True))
        missing_records = [
            ClassAssignmentRecord(assignment=assignment, user=s.user)
            for s in students if s.user_id not in existing_user_ids
        ]
        if missing_records:
            ClassAssignmentRecord.objects.bulk_create(missing_records)
        
        # 通知班级所有学生有新作业
        Notification.notify_many(
            recipients=class_obj.get_students(),
            sender=request.user,
            ntype='assignment',
            title=f'新作业：{assignment.title}',
            content=f'班级「{class_obj.name}」发布了新作业《{assignment.title}》，截止 {assignment.deadline.strftime("%m-%d %H:%M")}，请及时完成。',
            link=f'/quiz/class/{class_id}/assignments/{assignment_id}/'
        )
        messages.success(request, f'作业 "{assignment.title}" 已发布！')
        return redirect('class_assignments', class_id=class_id)
    
    return render(request, 'quiz/frontend/publish_class_assignment.html', {
        'class_obj': class_obj,
        'assignment': assignment
    })


@login_required
def allow_exam(request, class_id, assignment_id):
    """允许考试"""
    class_obj = get_object_or_404(Class, pk=class_id)
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id, class_obj=class_obj)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能操作')
        return redirect('class_assignment_detail', class_id=class_id, assignment_id=assignment_id)
    
    assignment.is_allow_exam = True
    assignment.save()
    
    messages.success(request, f'已允许考试：{assignment.title}')
    return redirect('class_assignment_detail', class_id=class_id, assignment_id=assignment_id)


@login_required
def close_exam(request, class_id, assignment_id):
    """关闭考试"""
    class_obj = get_object_or_404(Class, pk=class_id)
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id, class_obj=class_obj)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能操作')
        return redirect('class_assignment_detail', class_id=class_id, assignment_id=assignment_id)
    
    assignment.is_allow_exam = False
    assignment.save()
    
    messages.success(request, f'已关闭考试：{assignment.title}')
    return redirect('class_assignment_detail', class_id=class_id, assignment_id=assignment_id)


@login_required
def reset_exam_status(request, class_id, assignment_id):
    """重置考试状态（清空所有答题记录）"""
    class_obj = get_object_or_404(Class, pk=class_id)
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id, class_obj=class_obj)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能操作')
        return redirect('class_assignment_detail', class_id=class_id, assignment_id=assignment_id)
    
    if request.method == 'POST':
        # 清理关联的 TestRecord（与 delete_class_assignment 一致），避免遗留孤立成绩
        records = ClassAssignmentRecord.objects.filter(assignment=assignment)
        test_record_ids = list(
            records.exclude(test_record__isnull=True).values_list('test_record_id', flat=True)
        )
        if test_record_ids:
            TestRecord.objects.filter(id__in=test_record_ids).delete()
        records.delete()

        students = Profile.objects.filter(class_obj=class_obj, approval_status=1)
        for student in students:
            ClassAssignmentRecord.objects.create(assignment=assignment, user=student.user)
        
        messages.success(request, f'已重置考试状态：{assignment.title}')
        return redirect('class_assignment_detail', class_id=class_id, assignment_id=assignment_id)
    
    return render(request, 'quiz/frontend/reset_exam_status.html', {
        'class_obj': class_obj,
        'assignment': assignment
    })


@login_required
def delete_class_assignment(request, class_id, assignment_id):
    """删除班级作业/考试"""
    class_obj = get_object_or_404(Class, pk=class_id)
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id, class_obj=class_obj)
    
    is_admin = ClassAdmin.objects.filter(class_obj=class_obj, user=request.user).exists()
    if not is_admin:
        messages.error(request, '只有班级管理员才能删除作业')
        return redirect('class_assignments', class_id=class_id)
    
    if request.method == 'POST':
        # 删除相关的答题记录和测试记录
        # P1-5：批量收集 test_record_id 一次删除，避免逐条 record.test_record.delete() 触发 N+1
        records = ClassAssignmentRecord.objects.filter(assignment=assignment)
        test_record_ids = list(
            records.exclude(test_record__isnull=True)
            .values_list('test_record_id', flat=True)
        )
        if test_record_ids:
            TestRecord.objects.filter(id__in=test_record_ids).delete()
        records.delete()
        
        # 删除作业本身
        assignment_title = assignment.title
        assignment.delete()
        
        messages.success(request, f'已删除作业：{assignment_title}')
        return redirect('class_assignments', class_id=class_id)
    
    return render(request, 'quiz/frontend/delete_class_assignment.html', {
        'class_obj': class_obj,
        'assignment': assignment
    })


@login_required
def student_class_assignments(request):
    """学生班级作业/考试列表页面 - 显示每个作业的最高分记录"""
    # 获取用户班级信息
    try:
        profile = Profile.objects.get(user=request.user)
    except Profile.DoesNotExist:
        messages.error(request, '请先完善您的个人信息')
        return redirect('user_center')
    
    if not profile.class_obj:
        messages.error(request, '您还没有加入任何班级')
        return redirect('user_center')
    
    # 获取类型参数（1=作业，2=考试）
    current_type = request.GET.get('type', '1')
    try:
        current_type = int(current_type)
    except ValueError:
        current_type = 1
    
    # 获取班级作业列表
    assignments = ClassAssignment.objects.filter(
        class_obj=profile.class_obj,
        status=1,
        type=current_type
    ).order_by('-published_at')
    
    # 构建作业列表数据
    now = timezone.now()
    assignment_list = []
    for assignment in assignments:
        # 直接查询每个作业的最新提交记录（按attempt降序）
        record = ClassAssignmentRecord.objects.filter(
            assignment=assignment,
            user=request.user,
            is_submitted=True
        ).order_by('-attempt').first()
        is_submitted = record is not None
        is_overdue = assignment.deadline < now
        
        assignment_list.append({
            'assignment': assignment,
            'record': record,
            'is_submitted': is_submitted,
            'is_overdue': is_overdue
        })
    
    response = render(request, 'quiz/frontend/student_class_assignments.html', {
        'class_obj': profile.class_obj,
        'assignment_list': assignment_list,
        'current_type': current_type,
        'now': now
    })
    
    # 设置防缓存响应头
    response['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response['Pragma'] = 'no-cache'
    response['Expires'] = '0'
    
    return response

@login_required
def do_class_assignment(request, assignment_id):
    """完成班级作业/考试页面"""
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id)
    
    # 检查作业状态
    if assignment.status != 1:
        messages.error(request, '该作业尚未发布')
        return redirect('student_class_assignments')
    
    # 考试模式：检查是否允许考试
    if assignment.type == 2 and not assignment.is_allow_exam:
        messages.error(request, '该考试已关闭')
        return redirect('student_class_assignments')
    
    # 获取用户最新的答题记录
    latest_record = ClassAssignmentRecord.objects.filter(
        assignment=assignment,
        user=request.user
    ).order_by('-attempt').first()
    
    # 考试模式：只能有一次提交
    if assignment.type == 2 and latest_record and latest_record.is_submitted:
        messages.error(request, '您已经提交过该考试')
        return redirect('student_class_assignments')
    
    # POST 请求处理提交
    if request.method == 'POST':
        # 截止时间校验：过期后禁止提交（作业/考试统一生效）
        if assignment.deadline and timezone.now() > assignment.deadline:
            messages.error(request, '该作业/考试已过截止时间，无法提交')
            return redirect('student_class_assignments')
        # 创建新记录（作业模式始终创建新记录，考试模式重用未提交的记录）
        if assignment.type == 2 and latest_record and not latest_record.is_submitted:
            record = latest_record
        else:
            attempt = latest_record.attempt + 1 if latest_record else 1
            record = ClassAssignmentRecord.objects.create(
                assignment=assignment,
                user=request.user,
                start_time=timezone.now(),
                attempt=attempt
            )
        
        if assignment.test_paper:
            test_paper = assignment.test_paper
            questions = list(test_paper.questions.all())
            
            # 获取用户答案（P2-2 公共函数）
            user_answers = collect_user_answers(questions, request.POST)
            
            # 计算分数
            score, correct_count, wrong_count, total_count, question_results = calculate_score(questions, user_answers)
            
            # 更新作业记录
            record.score = score
            record.is_submitted = True
            record.submitted_at = timezone.now()
            record.save()
            
            # 创建测试记录 + 答案记录（P2-2 公共函数）
            test_record, _ = create_test_and_answer_records(
                request.user, test_paper, questions, score, question_results)
            
            # 关联测试记录
            record.test_record = test_record
            record.save()
            
            messages.success(request, f'{"考试" if assignment.type == 2 else "作业"}提交成功！得分：{score}分')
        else:
            record.is_submitted = True
            record.submitted_at = timezone.now()
            record.save()
            messages.success(request, f'{"考试" if assignment.type == 2 else "作业"}提交成功！')
        
        # 重定向到作业列表，添加时间戳防止缓存
        return redirect(f'{reverse("student_class_assignments")}?t={int(timezone.now().timestamp())}')
    
    # GET 请求：显示答题页面
    # 考试模式：自动创建或获取答题记录以启动计时器
    record_for_timer = latest_record
    if assignment.type == 2 and assignment.time_limit:
        if not latest_record or latest_record.is_submitted:
            # 首次进入考试，创建记录并记录开始时间
            attempt = 1
            if latest_record and latest_record.is_submitted:
                attempt = latest_record.attempt + 1
            record_for_timer = ClassAssignmentRecord.objects.create(
                assignment=assignment,
                user=request.user,
                start_time=timezone.now(),
                attempt=attempt
            )
        # 检查是否超时
        if record_for_timer.start_time:
            time_elapsed = (timezone.now() - record_for_timer.start_time).total_seconds() / 60
            if time_elapsed > assignment.time_limit:
                # 超时自动提交（得0分）
                record_for_timer.score = 0
                record_for_timer.is_submitted = True
                record_for_timer.submitted_at = timezone.now()
                record_for_timer.save()
                
                # 创建测试记录
                if assignment.test_paper:
                    test_paper = assignment.test_paper
                    test_record = TestRecord.objects.create(
                        user=request.user,
                        test_paper=test_paper,
                        score=0,
                        total_score=test_paper.total_score,
                        completed_at=timezone.now()
                    )
                    # 创建空白答案记录
                    for q in test_paper.questions.all():
                        AnswerRecord.objects.create(
                            test_record=test_record,
                            question=q,
                            user_answer='',
                            correct_answer=q.correct_answer,
                            is_correct=False,
                            original_question_content=q.content,
                            original_question_type=q.type,
                            original_options=parse_options(q.options),
                            original_explanation=q.explanation
                        )
                    record_for_timer.test_record = test_record
                    record_for_timer.save()
                
                messages.error(request, '考试已超时，系统已自动提交（得0分）')
                return redirect('student_class_assignments')
    
    # 获取题目列表
    questions = []
    test_paper = None
    if assignment.test_paper:
        test_paper = assignment.test_paper
        questions = list(test_paper.questions.all())
        for q in questions:
            q.options = parse_options(q.options)
    
    # 计算剩余时间（仅考试模式）
    remaining_seconds = None
    if assignment.type == 2 and assignment.time_limit and record_for_timer and record_for_timer.start_time:
        elapsed_seconds = (timezone.now() - record_for_timer.start_time).total_seconds()
        remaining_seconds = int(max(0, assignment.time_limit * 60 - elapsed_seconds))
    
    return render(request, 'quiz/frontend/do_class_assignment.html', {
        'assignment': assignment,
        'questions': questions,
        'test_paper': test_paper,
        'remaining_seconds': remaining_seconds,
        'show_answer': False,
        'record': latest_record
    })

@login_required
def submit_class_assignment(request, assignment_id):
    """提交班级作业/考试（AJAX接口）"""
    try:
        assignment = get_object_or_404(ClassAssignment, pk=assignment_id)
        
        if request.method != 'POST':
            return JsonResponse({'success': False, 'message': '无效的请求'})
        
        # 获取用户最新的答题记录（已提交/未提交的都算）
        latest_record = ClassAssignmentRecord.objects.filter(
            assignment=assignment,
            user=request.user
        ).order_by('-attempt').first()
        
        # 截止时间校验：过期后禁止提交
        if assignment.deadline and timezone.now() > assignment.deadline:
            return JsonResponse({'success': False, 'message': '该作业/考试已过截止时间，无法提交'})

        # 考试模式：只能提交一次
        if assignment.type == 2 and latest_record and latest_record.is_submitted:
            return JsonResponse({'success': False, 'message': '已经提交过该考试'})

        # 创建/获取答题记录
        if assignment.type == 2 and latest_record and not latest_record.is_submitted:
            record = latest_record
        else:
            attempt = latest_record.attempt + 1 if latest_record else 1
            record = ClassAssignmentRecord.objects.create(
                assignment=assignment,
                user=request.user,
                start_time=timezone.now(),
                attempt=attempt
            )

        # 考试模式：限时超时校验（服务端兜底，防绕过前端倒计时）
        if assignment.type == 2 and assignment.time_limit and record.start_time:
            elapsed_minutes = (timezone.now() - record.start_time).total_seconds() / 60
            if elapsed_minutes > assignment.time_limit:
                return JsonResponse({'success': False, 'message': '考试已超时，无法提交'})
        
        if assignment.test_paper:
            test_paper = assignment.test_paper
            questions = list(test_paper.questions.all())
            
            # 获取用户答案（P2-2 公共函数）
            user_answers = collect_user_answers(questions, request.POST)
            
            # 计算分数
            score, correct_count, wrong_count, total_count, question_results = calculate_score(questions, user_answers)
            
            # 更新记录
            record.score = score
            record.is_submitted = True
            record.submitted_at = timezone.now()
            record.save()
            
            # 创建测试记录 + 答案记录（P2-2 公共函数）
            test_record, _ = create_test_and_answer_records(
                request.user, test_paper, questions, score, question_results)
            
            record.test_record = test_record
            record.save()
            
            return JsonResponse({
                'success': True,
                'message': f'提交成功！得分：{score}分',
                'score': score
            })
        else:
            record.is_submitted = True
            record.submitted_at = timezone.now()
            record.save()
            return JsonResponse({'success': True, 'message': '提交成功！'})
    
    except Exception as e:
        error_info = f'Error: {str(e)}\n{traceback.format_exc()}'
        print(error_info)
        return JsonResponse({'success': False, 'message': f'提交失败: {str(e)}'})

# 后台管理视图
