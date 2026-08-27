# 本模块由 quiz/views.py 拆分生成（P2-1），公共依赖（import/类/常量/工具函数）见 views_common.py
from .views_common import *  # noqa: F401,F403

# 答题视图
def question_detail(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    if request.method == 'POST':
        user_answer = request.POST.get('answer')
        if user_answer == question.correct_answer:
            result = '正确'
        else:
            result = '错误'
        return render(request, 'quiz/frontend/answer_result.html', {
            'question': question,
            'user_answer': user_answer,
            'result': result,
            'correct_answer': question.correct_answer
        })
    return render(request, 'quiz/frontend/question_detail.html', {'question': question})

def test_paper_list(request):
    user = request.user
    # 搜索筛选参数
    search = request.GET.get('search', '').strip()
    sort = request.GET.get('sort', 'newest')  # newest / score / questions

    if user.is_staff:
        test_papers = TestPaper.objects.filter(is_published=True)
    else:
        test_papers = TestPaper.objects.filter(
            is_published=True
        ).filter(
            models.Q(is_public=True) | models.Q(created_by=user.username)
        )
    # 关键词搜索（标题或描述模糊匹配）
    if search:
        test_papers = test_papers.filter(
            models.Q(title__icontains=search) | models.Q(description__icontains=search)
        )
    # 注题量用于排序与展示
    test_papers = test_papers.annotate(
        question_count=Count('questions', distinct=True)
    )
    # 排序
    if sort == 'score':
        test_papers = test_papers.order_by('-total_score', '-created_at')
    elif sort == 'questions':
        test_papers = test_papers.order_by('-question_count', '-created_at')
    else:
        test_papers = test_papers.order_by('-created_at')

    paginated_test_papers = paginate_queryset(test_papers, request.GET.get('page', 1))

    context = {
        'test_papers': paginated_test_papers,
        'search': search,
        'sort': sort,
    }

    # Hero 区全站统计（公开试卷 + 公开题目，不受搜索影响）
    # P2-4：加 5 分钟 cache，避免每次列表页都 count 全表
    hero_stats = cache.get_or_set(
        'hero_stats',
        lambda: {
            'total_papers': TestPaper.objects.filter(
                is_published=True, is_public=True).count(),
            'total_questions': Question.objects.filter(is_public=True).count(),
        },
        300,
    )
    context['total_papers'] = hero_stats['total_papers']
    context['total_questions'] = hero_stats['total_questions']

    # 登录用户个性化数据（错题数 + profile 统计）
    if user.is_authenticated:
        try:
            profile = user.profile
        except Profile.DoesNotExist:
            profile = Profile.objects.create(user=user)
        context['wrong_count'] = WrongQuestion.objects.filter(user=user).count()
        context['profile'] = profile
        # P1-4：accuracy_rate 改为从 AnswerRecord 实时聚合，不依赖 Profile.accuracy_rate 字段
        ans_stats = AnswerRecord.objects.filter(test_record__user=user).aggregate(
            total=Count('id'),
            correct=Count('id', filter=Q(is_correct=True)),
        )
        if ans_stats['total'] > 0:
            context['accuracy_rate'] = int(ans_stats['correct'] / ans_stats['total'] * 100)
        else:
            context['accuracy_rate'] = 0

    return render(request, 'quiz/frontend/test_paper_list.html', context)

def test_paper_detail(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    user = request.user
    if not test_paper.is_public and (not user.is_authenticated or (test_paper.created_by != user.username and not user.is_staff)):
        raise Http404('试卷不存在或无权访问')
    questions = list(test_paper.questions.all())
    for q in questions:
        q.options = parse_options(q.options)

    # ===== P2-3 考试控制：时间窗口 + 次数限制 + 倒计时 =====
    exam_block = None
    remaining_seconds = None
    attempt_used = 0
    if user.is_authenticated:
        now = timezone.now()
        attempt_used = TestRecord.objects.filter(user=user, test_paper=test_paper).count()
        # 时间窗口
        if test_paper.start_time and now < test_paper.start_time:
            exam_block = '该试卷尚未开放，开放时间：' + test_paper.start_time.strftime('%Y-%m-%d %H:%M')
        elif test_paper.end_time and now > test_paper.end_time:
            exam_block = '该试卷已结束答题（截止时间：' + test_paper.end_time.strftime('%Y-%m-%d %H:%M') + '）'
        # 次数限制
        if not exam_block and test_paper.max_attempts and attempt_used >= test_paper.max_attempts:
            exam_block = '您已达到该试卷的最大答题次数（' + str(test_paper.max_attempts) + ' 次），无法再次作答'
        # 倒计时（基于会话记录的开始时间，刷新不重置）
        if not exam_block and test_paper.duration:
            import time as _time
            sess_key = 'exam_start_{}'.format(paper_id)
            start_ts = request.session.get(sess_key)
            if not start_ts:
                start_ts = _time.time()
                request.session[sess_key] = start_ts
                request.session.modified = True
            try:
                elapsed = _time.time() - float(start_ts)
            except (TypeError, ValueError):
                elapsed = 0
            remaining_seconds = max(0, int(test_paper.duration * 60 - elapsed))
            if remaining_seconds <= 0:
                exam_block = '答题时间已到，请提交试卷'
    # ===== P2-3 END =====

    # 预格式化短变量，避免模板里 {{ test_paper.start_time|date:"m-d H:i" }} 跨行/超长
    start_time_str = test_paper.start_time.strftime('%m-%d %H:%M') if test_paper.start_time else ''
    end_time_str = test_paper.end_time.strftime('%m-%d %H:%M') if test_paper.end_time else ''
    return render(request, 'quiz/frontend/test_paper_detail.html', {
        'test_paper': test_paper,
        'questions': questions,
        'exam_block': exam_block,
        'remaining_seconds': remaining_seconds,
        'attempt_used': attempt_used,
        'ma': test_paper.max_attempts,
        'st': start_time_str,
        'et': end_time_str,
    })

@login_required
def submit_test_paper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    questions = list(test_paper.questions.all())

    if request.method == 'POST':
        # ===== P2-3 服务端校验：时间窗口 + 次数上限（防绕过）=====
        now = timezone.now()
        if test_paper.start_time and now < test_paper.start_time:
            messages.error(request, '该试卷尚未开放，无法提交')
            return redirect('test_paper_detail', paper_id=paper_id)
        if test_paper.end_time and now > test_paper.end_time:
            messages.error(request, '该试卷已结束答题，无法提交')
            return redirect('test_paper_detail', paper_id=paper_id)
        if test_paper.max_attempts:
            taken = TestRecord.objects.filter(user=request.user, test_paper=test_paper).count()
            if taken >= test_paper.max_attempts:
                messages.error(request, '您已达到该试卷的最大答题次数，无法再次提交')
                return redirect('test_paper_detail', paper_id=paper_id)
        # 限时校验：基于会话记录的开始时间判断是否超时（服务端兜底，防绕过倒计时）
        if test_paper.duration:
            import time as _time
            start_ts = request.session.get('exam_start_{}'.format(paper_id))
            if start_ts:
                try:
                    elapsed = _time.time() - float(start_ts)
                except (TypeError, ValueError):
                    elapsed = 0
                if elapsed > test_paper.duration * 60:
                    messages.error(request, '答题时间已到，无法提交')
                    return redirect('test_paper_detail', paper_id=paper_id)
        # 清除倒计时开始时间
        sess_key = 'exam_start_{}'.format(paper_id)
        if sess_key in request.session:
            del request.session[sess_key]
            request.session.modified = True
        # ===== P2-3 END =====
        user_answers = collect_user_answers(questions, request.POST)
        
        score, correct_count, wrong_count, total_count, question_results = calculate_score(questions, user_answers)
        
        # 查找或创建用户档案
        try:
            profile = Profile.objects.get(user=request.user)
        except Profile.DoesNotExist:
            profile = Profile.objects.create(user=request.user)
        
        # 创建答题记录 + 答案记录（P2-2 公共函数，bulk_create 一次性插入）
        test_record, wrong_questions_list = create_test_and_answer_records(
            request.user, test_paper, questions, score, question_results)
        
        # 自动添加错题到错题本
        for question in wrong_questions_list:
            WrongQuestion.objects.get_or_create(
                user=request.user,
                question=question,
                defaults={
                    'user_answer': user_answers.get(question.id, ''),
                    'correct_answer': question.correct_answer
                }
            )
        
        # 更新用户学习统计（用 F 表达式避免并发读-改-写竞态导致更新丢失）
        # P1-4：移除 accuracy_rate=accuracy 写入——该字段语义错误（仅存本次正确率），
        # user_center 与 test_paper_list 均改为从 AnswerRecord 实时聚合，避免冗余且语义一致。
        Profile.objects.filter(pk=profile.pk).update(
            total_score=F('total_score') + score,
            tests_taken=F('tests_taken') + 1,
        )
        profile.refresh_from_db()
        
        return render(request, 'quiz/frontend/test_paper_result.html', {
            'test_paper': test_paper,
            'score': score,
            'correct_count': correct_count,
            'wrong_count': wrong_count,
            'total_count': total_count,
            'question_results': question_results,
            'test_record': test_record
        })
    
    for q in questions:
        q.options = parse_options(q.options)
    
    return render(request, 'quiz/frontend/test_paper_detail.html', {
        'test_paper': test_paper,
        'questions': questions
    })

@login_required
def test_history(request):
    # select_related 避免 record.test_paper 外键 N+1；annotate 一次算出 question_count（原循环 count）
    test_records = TestRecord.objects.filter(user=request.user).select_related(
        'test_paper'
    ).annotate(question_count=Count('test_paper__questions')).order_by('-completed_at')
    paginated_records = paginate_queryset(test_records, request.GET.get('page', 1), items_per_page=10)

    return render(request, 'quiz/frontend/test_history.html', {
        'test_records': paginated_records
    })

@login_required
def test_history_detail(request, record_id):
    test_record = get_object_or_404(TestRecord, pk=record_id, user=request.user)
    
    # 检查这个记录是否属于班级作业
    from .models import ClassAssignmentRecord
    assignment_record = ClassAssignmentRecord.objects.filter(test_record=test_record).first()
    is_assignment = assignment_record is not None
    
    # 获取试卷的题目列表（按原顺序）
    questions = []
    if test_record.test_paper:
        questions = list(test_record.test_paper.questions.all())
    
    # 获取所有答案记录
    answer_records = AnswerRecord.objects.filter(test_record=test_record).select_related('question')
    
    # 创建题目ID到答案记录的映射
    answer_map = {ar.question.id: ar for ar in answer_records}
    
    # 按照试卷题目顺序重新排列答案记录
    sorted_answer_records = []
    for question in questions:
        if question.id in answer_map:
            sorted_answer_records.append(answer_map[question.id])
    
    # 处理 question.options 字段，确保它是正确的字典格式
    for ar in sorted_answer_records:
        if ar.question:
            ar.question.options = parse_options(ar.question.options)
    
    return render(request, 'quiz/frontend/test_history_detail.html', {
        'test_record': test_record,
        'answer_records': sorted_answer_records,
        'is_assignment': is_assignment
    })




@login_required
def wrong_question_notebook(request):
    status = request.GET.get('status', 'all')
    now = timezone.now()

    qs = WrongQuestion.objects.filter(user=request.user).select_related('question')
    # 状态筛选：待复习 = 未复习 或 已到下次复习时间
    if status == 'pending':
        qs = qs.filter(Q(review_status='new') | Q(next_review_at__lte=now))
    elif status in ('new', 'reviewing', 'mastered', 'difficult'):
        qs = qs.filter(review_status=status)
    qs = qs.order_by('-added_at')

    # 处理每个错题的选项字段
    for wq in qs:
        wq.question.options = parse_options(wq.question.options)

    paginated_wrong_questions = paginate_queryset(qs, request.GET.get('page', 1), items_per_page=10)

    # 各复习状态统计
    # P2-8：6 次独立查询合并为 1 次 aggregate with conditional Count
    base = WrongQuestion.objects.filter(user=request.user)
    review_stats = base.aggregate(
        total=models.Count('id'),
        new=models.Count('id', filter=Q(review_status='new')),
        reviewing=models.Count('id', filter=Q(review_status='reviewing')),
        difficult=models.Count('id', filter=Q(review_status='difficult')),
        mastered=models.Count('id', filter=Q(review_status='mastered')),
        pending=models.Count('id', filter=Q(review_status='new') | Q(next_review_at__lte=now)),
    )
    review_stats = {k: (v or 0) for k, v in review_stats.items()}

    return render(request, 'quiz/frontend/wrong_question_notebook.html', {
        'wrong_questions': paginated_wrong_questions,
        'status': status,
        'review_stats': review_stats,
    })

@login_required
def wrong_question_review(request, wrong_question_id):
    """标记错题复习状态：mastered 已掌握 / reviewing 记录一次复习（间隔重复算法）"""
    if request.method != 'POST':
        return redirect('wrong_question_notebook')
    wq = get_object_or_404(WrongQuestion, id=wrong_question_id, user=request.user)
    action = request.POST.get('action', 'reviewing')
    if action == 'mastered':
        wq.review_status = 'mastered'
        wq.next_review_at = None
        wq.last_reviewed_at = timezone.now()
        wq.save()
        messages.success(request, '已标记为「已掌握」🎯')
    else:
        wq.review_count += 1
        wq.last_reviewed_at = timezone.now()
        # 艾宾浩斯间隔重复：1/3/7/15/30 天递增
        intervals = [1, 3, 7, 15, 30]
        days = intervals[min(wq.review_count - 1, len(intervals) - 1)]
        wq.next_review_at = timezone.now() + timedelta(days=days)
        wq.review_status = 'reviewing' if wq.review_count < 3 else 'difficult'
        wq.save()
        messages.success(request, f'已记录复习（第{wq.review_count}次），下次复习时间：{wq.next_review_at.strftime("%m-%d %H:%M")} 📅')
    return redirect('wrong_question_notebook')

@login_required
def create_wrong_question_paper(request):
    if request.method == 'POST':
        # 来自错题本页面的组卷请求
        selected_ids = request.POST.getlist('selected_questions')
        if not selected_ids:
            messages.error(request, '请至少选择一道题目')
            return redirect('wrong_question_notebook')
        
        # 创建试卷
        test_paper = TestPaper.objects.create(
            title='错题巩固试卷',
            description='错题巩固试卷',
            created_by=request.user.username,
            is_published=False
        )
        
        # 一次查询所有题目（原逐题 get，N+1）；m2m_changed 自动更新 total_score，无需手动算
        questions = list(Question.objects.filter(id__in=selected_ids))
        test_paper.questions.set(questions)

        return redirect('submit_wrong_question_paper', paper_id=test_paper.id)
    
    # GET请求时重定向到错题本选择页面
    return redirect('wrong_question_notebook')

@login_required
def submit_wrong_question_paper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    questions = list(test_paper.questions.all())
    
    if request.method == 'POST':
        user_answers = collect_user_answers(questions, request.POST)
        
        score, correct_count, wrong_count, total_count, question_results = calculate_score(questions, user_answers)
        
        # 创建答题记录 + 答案记录（P2-2 公共函数）
        test_record, wrong_questions_list = create_test_and_answer_records(
            request.user, test_paper, questions, score, question_results, is_wrong_paper=True)
        
        # 删除旧错题，然后重新添加答错的题目
        wrong_question_ids = set(WrongQuestion.objects.filter(
            user=request.user, question__in=questions).values_list('question_id', flat=True))
        WrongQuestion.objects.filter(user=request.user, question__in=questions).delete()
        
        # 重新添加这次答错的题
        re_added_count = 0
        for question in wrong_questions_list:
            WrongQuestion.objects.get_or_create(
                user=request.user,
                question=question,
                defaults={
                    'user_answer': user_answers.get(question.id, ''),
                    'correct_answer': question.correct_answer
                }
            )
            re_added_count += 1
        
        return render(request, 'quiz/frontend/wrong_question_paper_result.html', {
            'test_paper': test_paper,
            'score': score,
            'correct_count': correct_count,
            'wrong_count': wrong_count,
            'total_count': total_count,
            'question_results': question_results,
            'test_record': test_record,
            'deleted_wrong_questions': len(wrong_question_ids),
            're_added_count': re_added_count
        })
    
    for q in questions:
        q.options = parse_options(q.options)
    
    return render(request, 'quiz/frontend/wrong_question_paper.html', {
        'test_paper': test_paper,
        'questions': questions,
        'total_score': test_paper.total_score
    })

@login_required
def delete_wrong_question(request, wrong_question_id):
    wrong_question = get_object_or_404(WrongQuestion, pk=wrong_question_id, user=request.user)
    wrong_question.delete()
    messages.success(request, '已从错题本中删除')
    return redirect('wrong_question_notebook')

@login_required
def my_test_papers(request):
    """我的试卷 - 列表 + 搜索/筛选/排序 + 聚合统计"""
    user = request.user
    base_qs = TestPaper.objects.filter(created_by=user.username).annotate(
        question_count=models.Count('questions')
    )

    # 搜索：标题
    q = request.GET.get('q', '').strip()
    if q:
        base_qs = base_qs.filter(title__icontains=q)

    # 筛选：状态（published/unpublished/exam）
    status = request.GET.get('status', '')
    if status == 'published':
        base_qs = base_qs.filter(is_published=True)
    elif status == 'unpublished':
        base_qs = base_qs.filter(is_published=False)
    elif status == 'exam':
        base_qs = base_qs.filter(
            models.Q(duration__isnull=False) | models.Q(max_attempts__isnull=False) |
            models.Q(start_time__isnull=False) | models.Q(end_time__isnull=False)
        )

    # 排序
    sort = request.GET.get('sort', 'date')
    sort_map = {
        'date': '-created_at',
        'score': '-total_score',
        'questions': '-question_count',
        'title': 'title',
    }
    base_qs = base_qs.order_by(sort_map.get(sort, '-created_at'))

    paginated = paginate_queryset(base_qs, request.GET.get('page', 1))

    # 聚合统计（基于自己创建的全部试卷，不受搜索影响）
    # P2-7：5 次独立 count 合并为 1 次 aggregate with conditional Count
    stats = TestPaper.objects.filter(created_by=user.username).aggregate(
        total=models.Count('id'),
        published=models.Count('id', filter=models.Q(is_published=True)),
        unpublished=models.Count('id', filter=models.Q(is_published=False)),
        exam_controlled=models.Count('id', filter=(
            models.Q(duration__isnull=False) | models.Q(max_attempts__isnull=False) |
            models.Q(start_time__isnull=False) | models.Q(end_time__isnull=False)
        )),
        total_questions=models.Count('questions'),
    )
    stats = {k: (v or 0) for k, v in stats.items()}

    # 分页保留搜索参数：去掉 page 后的查询串
    base_query_dict = request.GET.copy()
    base_query_dict.pop('page', None)
    base_query = base_query_dict.urlencode()

    return render(request, 'quiz/frontend/my_test_papers.html', {
        'test_papers': paginated,
        'stats': stats,
        'q': q,
        'status': status,
        'sort': sort,
        'base_query': base_query,
    })

@login_required
def create_test_paper(request):
    """手工组卷 - 创建试卷视图"""
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        is_published = request.POST.get('is_published') == 'on'
        
        # 支持两种提交方式：隐藏域(selected_questions)和复选框(questions)
        selected_str = request.POST.get('selected_questions', '')
        if selected_str:
            question_ids = [id_str.strip() for id_str in selected_str.split(',') if id_str.strip()]
        else:
            question_ids = request.POST.getlist('questions')

        if title and question_ids:
            # ===== P2-3 考试控制参数（可选）=====
            import datetime as _dt
            def _parse_dt(s):
                if not s:
                    return None
                try:
                    dt = _dt.datetime.strptime(s, '%Y-%m-%dT%H:%M')
                except (ValueError, TypeError):
                    return None
                try:
                    return timezone.make_aware(dt)
                except Exception:
                    return dt
            duration = request.POST.get('duration') or None
            max_attempts = request.POST.get('max_attempts') or None
            start_time = _parse_dt(request.POST.get('start_time'))
            end_time = _parse_dt(request.POST.get('end_time'))
            test_paper = TestPaper.objects.create(
                title=title,
                description=description,
                created_by=request.user.username,
                is_published=is_published,
                duration=int(duration) if duration and duration.isdigit() else None,
                max_attempts=int(max_attempts) if max_attempts and max_attempts.isdigit() else None,
                start_time=start_time,
                end_time=end_time,
            )
            # ===== P2-3 END =====

            # 一次查询所有题目（原逐题 get，N+1）；m2m_changed 自动更新 total_score
            questions = list(Question.objects.filter(id__in=question_ids))
            test_paper.questions.set(questions)
            total_score = sum(q.score for q in questions)

            messages.success(request, f'试卷 "{title}" 创建成功！共 {len(questions)} 道题目，总分 {total_score} 分。')
            return redirect('my_test_papers')
        else:
            messages.error(request, '请填写试卷标题并至少选择一道题目')

    context = _paper_editor_context(request)
    if context.get('redirect_url'):
        return redirect(request.path + context['redirect_url'])
    return render(request, 'quiz/frontend/create_test_paper.html', context)


def _paper_editor_context(request, test_paper=None):
    """创建/编辑试卷共用的题库上下文（学科/章节/知识点 + 服务端筛选分页题目 + 已选 JSON）

    P2-5：原一次性加载全部题目序列化 JSON，>1000 题时内存/渲染卡顿。
    改为服务端筛选（subject/chapter/knowledge_point/type/min_score/max_score/search）+ 分页（50/页），
    已选题目通过 sel 参数跨页保留，随机选题由服务端在筛选结果中执行。
    """
    subjects = Subject.objects.all().order_by('name')
    chapters = Chapter.objects.select_related('subject').order_by('subject', 'number')
    knowledge_points = KnowledgePoint.objects.select_related(
        'section', 'section__chapter', 'subject').order_by('subject', 'name')

    # 直接传 Python 对象，由模板 json_script 序列化（避免双重序列化导致 JSON.parse 得到字符串）
    chapters_json = [{
        'id': ch.id, 'number': ch.number, 'title': ch.title,
        'subject_id': ch.subject.id if ch.subject else None
    } for ch in chapters]
    knowledge_points_json = [{
        'id': kp.id, 'name': kp.name,
        'chapter_id': kp.section.chapter.id if kp.section and kp.section.chapter else None,
        'subject_id': kp.subject.id if kp.subject else None
    } for kp in knowledge_points]

    # ===== 服务端筛选 =====
    questions = (get_visible_questions(request.user)
                 .select_related('subject', 'chapter', 'section')
                 .prefetch_related('knowledge_points'))

    subject_id = request.GET.get('subject', '')
    chapter_id = request.GET.get('chapter', '')
    kp_id = request.GET.get('knowledge_point', '')
    q_type = request.GET.get('type', '')
    search = request.GET.get('search', '').strip()
    min_score = request.GET.get('min_score', '')
    max_score = request.GET.get('max_score', '')

    if subject_id.isdigit():
        questions = questions.filter(subject_id=subject_id)
    if chapter_id.isdigit():
        questions = questions.filter(chapter_id=chapter_id)
    if kp_id.isdigit():
        questions = questions.filter(knowledge_points__id=kp_id)
    if q_type.isdigit():
        questions = questions.filter(type=q_type)
    if search:
        questions = questions.filter(models.Q(content__icontains=search))
    if min_score.isdigit():
        questions = questions.filter(score__gte=int(min_score))
    if max_score.isdigit():
        questions = questions.filter(score__lte=int(max_score))

    # 服务端随机选题：点击随机按钮时按当前筛选结果随机取 N 题
    random_questions = []
    random_count = request.GET.get('random', '')
    if random_count.isdigit() and int(random_count) > 0:
        random_questions = list(questions.order_by('?')[:int(random_count)])

    question_total = questions.count()
    page_obj = paginate_queryset(
        questions.order_by('id'), request.GET.get('page', 1), items_per_page=50)

    questions_list = []
    for q in page_obj.object_list:
        questions_list.append({
            'id': q.id, 'type': q.type, 'content': q.content,
            'options': parse_options(q.options),
            'score': q.score, 'explanation': q.explanation,
            'subject_id': q.subject.id if q.subject else '',
            'chapter_id': q.chapter.id if q.chapter else '',
            'knowledge_point_ids': [str(kp.id) for kp in q.knowledge_points.all()],
        })

    # ===== 已选题目（编辑模式预选 / 跨页已选）：解析 sel 参数 =====
    sel_str = request.GET.get('sel', '')
    sel_ids = [s for s in sel_str.split(',') if s.isdigit()]
    if not sel_ids and test_paper:
        sel_ids = list(test_paper.questions.values_list('id', flat=True))
    selected = list(Question.objects.filter(id__in=sel_ids))
    sel_questions = [{
        'id': q.id, 'content': q.content, 'score': q.score, 'type': q.type
    } for q in selected]

    # 随机选中的题目并入已选（JS 直接构造 selectedQuestions）
    if random_questions:
        sel_questions += [{
            'id': q.id, 'content': q.content, 'score': q.score, 'type': q.type
        } for q in random_questions]

    # 筛选参数回显 + 分页/筛选链接共用查询串
    filter_params = {
        'subject': subject_id, 'chapter': chapter_id, 'knowledge_point': kp_id,
        'type': q_type, 'min_score': min_score, 'max_score': max_score, 'search': search,
    }
    filter_query = '&'.join('{}={}'.format(k, v) for k, v in filter_params.items() if v)

    # 随机选题后 redirect 清理 random 参数（避免刷新重复随机），已选+随机题合并进 sel
    redirect_url = None
    if random_count.isdigit() and int(random_count) > 0 and random_questions:
        combined_ids = list(dict.fromkeys(sel_ids + [q.id for q in random_questions]))
        parts = [kv for kv in filter_query.split('&') if kv]
        parts.append('sel={}'.format(','.join(str(i) for i in combined_ids)))
        redirect_url = '?' + '&'.join(parts)

    return {
        'questions': questions_list,
        'page_obj': page_obj,
        'question_total': question_total,
        'subjects': subjects,
        'chapters': chapters,
        'knowledge_points': knowledge_points,
        'chapters_json': chapters_json,
        'knowledge_points_json': knowledge_points_json,
        'filter_params': filter_params,
        'filter_query': filter_query,
        'sel_questions': sel_questions,
        'redirect_url': redirect_url,
    }


@login_required
def edit_test_paper(request, paper_id):
    """编辑试卷 - 标题/描述/考试控制 + 重新选题（复用创建试卷 UI）"""
    test_paper = get_object_or_404(TestPaper, pk=paper_id, created_by=request.user.username)

    if request.method == 'POST':
        title = request.POST.get('title')
        selected_str = request.POST.get('selected_questions', '')
        if selected_str:
            question_ids = [s.strip() for s in selected_str.split(',') if s.strip()]
        else:
            question_ids = request.POST.getlist('questions')

        if title and question_ids:
            import datetime as _dt

            def _parse_dt(s):
                if not s:
                    return None
                try:
                    dt = _dt.datetime.strptime(s, '%Y-%m-%dT%H:%M')
                except (ValueError, TypeError):
                    return None
                try:
                    return timezone.make_aware(dt)
                except Exception:
                    return dt

            duration = request.POST.get('duration') or None
            max_attempts = request.POST.get('max_attempts') or None
            start_time = _parse_dt(request.POST.get('start_time'))
            end_time = _parse_dt(request.POST.get('end_time'))

            test_paper.title = title
            test_paper.description = request.POST.get('description')
            test_paper.is_published = request.POST.get('is_published') == 'on'
            test_paper.duration = int(duration) if duration and duration.isdigit() else None
            test_paper.max_attempts = int(max_attempts) if max_attempts and max_attempts.isdigit() else None
            test_paper.start_time = start_time
            test_paper.end_time = end_time
            test_paper.save()

            # 重新设置题目（m2m → total_score 由 m2m_changed 信号自动重算）
            questions = list(Question.objects.filter(id__in=question_ids))
            test_paper.questions.set(questions)
            total_score = sum(q.score for q in questions)

            messages.success(
                request,
                f'试卷 "{title}" 已更新！共 {len(questions)} 道题目，总分 {total_score} 分。')
            return redirect('my_test_papers')
        else:
            messages.error(request, '请填写试卷标题并至少选择一道题目')

    context = _paper_editor_context(request, test_paper=test_paper)
    if context.get('redirect_url'):
        return redirect(request.path + context['redirect_url'])
    context.update({
        'edit_mode': True,
        'test_paper': test_paper,
        'ps_pub': 'true' if test_paper.is_published else 'false',
    })
    return render(request, 'quiz/frontend/create_test_paper.html', context)


@login_required
def import_test_paper(request):
    """前台导入试卷 - 使用导入器类"""
    importer = FrontendTestPaperImporter(request)
    return importer.handle()

@login_required
def publish_test_paper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id, created_by=request.user.username)
    
    if request.method == 'POST':
        test_paper.is_published = not test_paper.is_published
        test_paper.save()
        if test_paper.is_published:
            messages.success(request, f'试卷 "{test_paper.title}" 已发布到全站')
        else:
            messages.success(request, f'试卷 "{test_paper.title}" 已取消发布')
        return redirect('my_test_papers')
    
    return render(request, 'quiz/frontend/publish_test_paper.html', {
        'test_paper': test_paper
    })

@login_required
def delete_test_paper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id, created_by=request.user.username)
    
    if request.method == 'POST':
        test_paper.delete()
        messages.success(request, '试卷已删除')
        return redirect('my_test_papers')
    
    return render(request, 'quiz/frontend/delete_test_paper.html', {
        'test_paper': test_paper
    })

