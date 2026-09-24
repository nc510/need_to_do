# 本模块由 quiz/views.py 拆分生成（P2-1），公共依赖（import/类/常量/工具函数）见 views_common.py
from .views_common import *  # noqa: F401,F403
from django.template.loader import render_to_string

# 错题组卷：单次题量上限（持「回响之杖（组卷卡）」时当次不限题量）
WRONG_PAPER_FREE_LIMIT = 10


def _wrong_paper_card_state(user):
    """返回 (组卷卡道具, 可用张数)；道具未上架时返回 (None, 0)。

    单独抽函数供错题本页面提示与组卷校验共用，保证两处口径一致。
    """
    from starcoin.models import StarItem
    from starcoin.services import available_quantity, get_active_item_by_effect
    card = get_active_item_by_effect(StarItem.EFFECT_WRONG_PAPER)
    return card, available_quantity(user, card) if card else 0


def _local_day_range():
    """本地自然日的 [起, 止) 时间区间。

    不用 created_at__date：该查询会走 MySQL CONVERT_TZ，本库未安装时区表时
    会静默匹配不到任何记录（返回 0），导致额度统计永久失效。
    """
    start = timezone.localtime(timezone.now()).replace(
        hour=0, minute=0, second=0, microsecond=0)
    return start, start + timedelta(days=1)


def _wrong_paper_free_used_today(user):
    """免费用户今日已用的免费组卷次数。

    口径 = 今日生成的错题组卷试卷数 - 今日用掉的组卷卡张数：
    组卷被拦截/失败不会留下试卷，天然不计数；用卡的那几次也不算免费额度。
    """
    from starcoin.models import StarItem, StarItemUsage
    start, end = _local_day_range()
    papers = TestPaper.objects.filter(
        created_by=user.username, is_wrong_paper=True,
        created_at__gte=start, created_at__lt=end).count()
    if not papers:
        return 0
    card_uses = StarItemUsage.objects.filter(
        user=user, effect_type=StarItem.EFFECT_WRONG_PAPER,
        created_at__gte=start, created_at__lt=end).count()
    return max(papers - card_uses, 0)


def _wrong_paper_quota_state(user):
    """返回 (是否会员, 每日免费次数上限, 今日剩余免费次数)。

    会员组卷不限次数，剩余次数用 -1 表示「不限」；上限来自后台「错题组卷额度」。
    """
    from starcoin.models import StarWrongPaperConfig
    from starcoin.services import is_member_active
    if is_member_active(user):
        return True, 0, -1
    limit = StarWrongPaperConfig.get_solo().free_daily_limit
    return False, limit, max(limit - _wrong_paper_free_used_today(user), 0)


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

def _annotate_my_paper_status(paginated_test_papers, user):
    """给当前页试卷补上「我的作答状态」字段（my_status/my_hint/my_btn_label 等）。

    批量聚合当前页的作答记录与草稿，避免逐份试卷查库；整页渲染与 AJAX 翻页共用。
    """
    page_papers = list(paginated_test_papers)
    paper_ids = [p.pk for p in page_papers]
    record_stats = {
        row['test_paper_id']: row
        for row in TestRecord.objects.filter(
            user=user, test_paper_id__in=paper_ids
        ).values('test_paper_id').annotate(
            cnt=Count('id'),
            best=models.Max('score'),
            last=models.Max('completed_at'),
        )
    }
    draft_ids = set(TestDraft.objects.filter(
        user=user, test_paper_id__in=paper_ids, is_wrong_paper=False
    ).values_list('test_paper_id', flat=True))
    now = timezone.now()
    for paper in page_papers:
        row = record_stats.get(paper.pk)
        paper.my_attempts = row['cnt'] if row else 0
        paper.my_best_score = row['best'] if row else 0
        paper.my_last_time = row['last'] if row else None
        paper.my_has_draft = paper.pk in draft_ids
        paper.my_remaining = None
        if paper.max_attempts:
            paper.my_remaining = max(0, paper.max_attempts - paper.my_attempts)
        paper.my_best_rate = int(
            paper.my_best_score * 100 / paper.total_score) if paper.total_score else 0
        # 状态：ended/upcoming（不可答） > done（已答） > doing（有草稿） > new（未作答）
        if paper.end_time and now > paper.end_time:
            paper.my_status, paper.my_status_label = 'ended', '已结束'
        elif paper.start_time and now < paper.start_time:
            paper.my_status, paper.my_status_label = 'upcoming', '未开放'
        elif paper.my_attempts:
            paper.my_status = 'done'
            paper.my_status_label = '已答 {} 次'.format(paper.my_attempts)
        elif paper.my_has_draft:
            paper.my_status, paper.my_status_label = 'doing', '答题中'
        else:
            paper.my_status, paper.my_status_label = 'new', '未作答'
        # 卡片提示语 + 按钮文案（模板内不再做多条件判断）
        if paper.my_status == 'ended':
            paper.my_hint = '该试卷已结束答题'
            paper.my_btn_label = '查看详情 →'
        elif paper.my_status == 'upcoming':
            paper.my_hint = '开放时间：' + paper.start_time.strftime('%m-%d %H:%M')
            paper.my_btn_label = '查看详情 →'
        elif paper.my_status == 'done':
            paper.my_hint = '最高 {} 分（得分率 {}%）· 最近 {}'.format(
                paper.my_best_score, paper.my_best_rate,
                paper.my_last_time.strftime('%m-%d %H:%M'))
            if paper.my_remaining is not None:
                if paper.my_remaining > 0:
                    paper.my_hint += ' · 剩余 {} 次机会'.format(paper.my_remaining)
                else:
                    paper.my_hint += ' · 已用完答题次数'
            paper.my_btn_label = '再次答题 →' if paper.my_remaining != 0 else '查看详情 →'
        elif paper.my_status == 'doing':
            paper.my_hint = '有未提交的作答记录，可继续答题'
            paper.my_btn_label = '继续答题 →'
        else:
            paper.my_hint = '尚未作答'
            if paper.max_attempts:
                paper.my_hint += ' · 共 {} 次机会'.format(paper.max_attempts)
            paper.my_btn_label = '开始答题 →'


# ===== 首页「全站试卷」分类导航（学科 / 章节 / 知识点 / 出题人）=====
# 试卷没有分类字段，分类统一由卷内题目的 subject/chapter/knowledge_points 派生；
# 在 M2M 上过滤一律走 through 表的 pk__in 子查询，不用 JOIN：
# JOIN 会让 annotate(Count('questions')) 与分页 count() 出现行膨胀和重复计数。

def _paper_ids_with(**question_filter):
    """「卷内至少有一道满足条件的题目」的试卷 ID 子查询。"""
    return TestPaper.questions.through.objects.filter(
        **question_filter).values('testpaper_id')


def _facet_url(params, path, **overrides):
    """在保留其余筛选条件的前提下覆盖分类参数，生成分类 chip 的链接。

    params 为当前查询串（不含 page）。切换学科时必须一并清空 chapter/topic，
    否则会残留上一个学科的章节上下文，导致筛出空结果。
    """
    query = params.copy()
    for field, value in overrides.items():
        if value:
            query[field] = value
        else:
            query.pop(field, None)
    encoded = query.urlencode()
    return path + ('?' + encoded if encoded else '')


def _chapter_label(number, title):
    """章节文案：标题自带「第X章」前缀时不再重复拼编号（与 Chapter.display_title 同口径）。"""
    cleaned = (title or '').replace('\u3000', ' ').strip()
    if not cleaned:
        return ''
    if strip_sequence_prefix(cleaned) != cleaned:
        return cleaned
    return '第{}章 {}'.format(number, cleaned) if number else cleaned


def _paper_category_nav(visible, subject_key, chapter_key, topic_key, params, path):
    """构造分类导航三行（学科 / 章节 / 知识点）。

    visible 为当前可见试卷集合（不受关键词搜索与分类筛选影响），计数逐级收敛：
    学科 = 全部可见试卷；章节 = 已选学科范围内；知识点再按已选章节收窄。
    知识点数量可能较多且交叉命中不可相加，故不给计数。
    """
    through = TestPaper.questions.through
    # ---- 学科行：卷内题目出现过的学科 + 「未分类」（题目未设学科的卷）----
    subject_items = [{
        'key': 'all', 'label': '全部', 'count': visible.count(),
        'active': subject_key == 'all', 'url': _facet_url(
            params, path, subject='', chapter='', topic=''),
    }]
    subject_rows = through.objects.filter(
        testpaper_id__in=visible.values('id'), question__subject__isnull=False
    ).values('question__subject_id', 'question__subject__name',
             'question__subject__icon').annotate(
        n=Count('testpaper_id', distinct=True)).order_by('-n')
    for row in subject_rows:
        key = str(row['question__subject_id'])
        subject_items.append({
            'key': key,
            'label': '{} {}'.format(
                row['question__subject__icon'] or '', row['question__subject__name']).strip(),
            'count': row['n'], 'active': subject_key == key,
            'url': _facet_url(params, path, subject=key, chapter='', topic=''),
        })
    uncategorized = visible.exclude(
        pk__in=_paper_ids_with(question__subject__isnull=False)).count()
    if uncategorized:
        subject_items.append({
            'key': 'none', 'label': '未分类', 'count': uncategorized,
            'active': subject_key == 'none',
            'url': _facet_url(params, path, subject='none', chapter='', topic=''),
        })

    # ---- 章节行 / 知识点行：选中具体学科后才展开，避免全站选项平铺 ----
    chapter_items, topic_items = [], []
    subject_paper_ids = None
    if subject_key.isdigit():
        subject_paper_ids = visible.filter(
            pk__in=_paper_ids_with(question__subject_id=int(subject_key))).values('id')
        chapter_items.append({
            'key': '', 'label': '全部章节', 'count': None, 'active': not chapter_key,
            'url': _facet_url(params, path, chapter='', topic=''),
        })
        chapter_rows = Chapter.objects.filter(
            subject_id=int(subject_key),
            questions__testpaper__in=subject_paper_ids,
        ).annotate(n=Count('questions__testpaper', distinct=True)).order_by('number')
        for chapter in chapter_rows:
            key = str(chapter.pk)
            chapter_items.append({
                'key': key, 'label': chapter.display_title, 'count': chapter.n,
                'active': chapter_key == key,
                'url': _facet_url(params, path, chapter=key, topic=''),
            })
    kp_base_ids = None
    if subject_paper_ids is not None:
        if chapter_key:
            kp_base_ids = visible.filter(
                pk__in=_paper_ids_with(question__chapter_id=int(chapter_key))).values('id')
        else:
            kp_base_ids = subject_paper_ids
    if kp_base_ids is not None:
        topic_items.append({
            'key': '', 'label': '全部知识点', 'count': None, 'active': not topic_key,
            'url': _facet_url(params, path, topic=''),
        })
        kp_ids = through.objects.filter(
            testpaper_id__in=kp_base_ids).values('question__knowledge_points')
        for kp in KnowledgePoint.objects.filter(id__in=kp_ids).order_by('name'):
            key = str(kp.pk)
            topic_items.append({
                'key': key, 'label': kp.name, 'count': None, 'active': topic_key == key,
                'url': _facet_url(params, path, topic=key),
            })
    if subject_key == 'none':
        chapter_hint = topic_hint = '未分类试卷未设置学科，无章节 / 知识点'
    elif subject_key.isdigit():
        chapter_hint, topic_hint = '该学科暂无可联动的章节', '该学科暂无可联动的知识点'
    else:
        chapter_hint, topic_hint = '选学科后展开该学科章节', '选学科后展开该学科知识点'
    return [
        {'key': 'subject', 'label': '学科', 'items': subject_items,
         'hint': '', 'scroll': False},
        {'key': 'chapter', 'label': '章节', 'items': chapter_items,
         'hint': chapter_hint, 'scroll': False},
        {'key': 'topic', 'label': '知识点', 'items': topic_items,
         'hint': topic_hint, 'scroll': True},
    ]


def _paper_author_options(visible, author):
    """出题人下拉选项：取自当前可见试卷集合，带份数（不随分类与搜索变化）。

    text 已在服务端拼好「名字（N）」：模板只做单行输出，
    避免 `{{ opt.name }}（{{ opt.count }}）` 被格式化折行。
    """
    options = [{'key': '', 'text': '全部出题人'}]
    rows = visible.exclude(created_by__isnull=True).exclude(created_by='').values(
        'created_by').annotate(n=Count('id')).order_by('-n', 'created_by')
    for row in rows:
        options.append({'key': row['created_by'],
                        'text': '{}（{}）'.format(row['created_by'], row['n'])})
    return options


def _annotate_paper_categories(paginated_test_papers):
    """给当前页试卷补上「学科 / 章节」徽标（取卷内命中题数最多的那个）。

    与 _annotate_my_paper_status 同为「当前页批量聚合」，整页渲染与 AJAX 翻页共用。
    """
    page_papers = list(paginated_test_papers)
    paper_ids = [paper.pk for paper in page_papers]
    if not paper_ids:
        return
    through = TestPaper.questions.through
    best_subject, best_chapter = {}, {}
    for row in through.objects.filter(
            testpaper_id__in=paper_ids, question__subject__isnull=False
    ).values('testpaper_id', 'question__subject__name', 'question__subject__icon'
             ).annotate(n=Count('id')):
        pid, n = row['testpaper_id'], row['n']
        if pid not in best_subject or n > best_subject[pid][0]:
            best_subject[pid] = (n, '{} {}'.format(
                row['question__subject__icon'] or '',
                row['question__subject__name']).strip())
    for row in through.objects.filter(
            testpaper_id__in=paper_ids, question__chapter__isnull=False
    ).values('testpaper_id', 'question__chapter__title',
             'question__chapter__number').annotate(n=Count('id')):
        pid, n = row['testpaper_id'], row['n']
        if pid not in best_chapter or n > best_chapter[pid][0]:
            best_chapter[pid] = (n, _chapter_label(
                row['question__chapter__number'], row['question__chapter__title']))
    for paper in page_papers:
        paper.subject_label = best_subject.get(paper.pk, (0, ''))[1]
        paper.chapter_label = best_chapter.get(paper.pk, (0, ''))[1]


def test_paper_list(request):
    user = request.user
    # 搜索筛选参数
    search = request.GET.get('search', '').strip()
    sort = request.GET.get('sort', 'oldest')  # oldest / newest / score / questions
    status = request.GET.get('status', 'all')  # all / undone / done（我的作答状态，仅登录用户）
    # 分类导航参数：subject=学科ID/none/all，chapter=章节ID，topic=知识点ID
    subject_key = request.GET.get('subject', 'all').strip()
    chapter_key = request.GET.get('chapter', '').strip()
    topic_key = request.GET.get('topic', '').strip()
    author = request.GET.get('author', '').strip()
    # 非法参数静默回落，避免手改 URL 造成空结果或报错
    if subject_key != 'none' and not subject_key.isdigit():
        subject_key = 'all'
    if not chapter_key.isdigit():
        chapter_key = ''
    if not topic_key.isdigit():
        topic_key = ''

    # 全站列表只展示「已发布 + 审核通过」的正式试卷
    listed = dict(is_published=True, is_wrong_paper=False,
                  review_status=TestPaper.REVIEW_APPROVED)
    if user.is_staff:
        test_papers = TestPaper.objects.filter(**listed)
    else:
        test_papers = TestPaper.objects.filter(**listed).filter(
            models.Q(is_public=True) | models.Q(created_by=user.username)
        )
    # 我可见的全部试卷：分类计数的口径基准（不受关键词搜索与分类筛选影响）
    progress_base = test_papers
    # 关键词搜索（标题或描述模糊匹配）
    if search:
        test_papers = test_papers.filter(
            models.Q(title__icontains=search) | models.Q(description__icontains=search)
        )
    # 分类筛选（派生口径：按卷内题目的学科 / 章节 / 知识点过滤）
    if subject_key == 'none':
        test_papers = test_papers.exclude(
            pk__in=_paper_ids_with(question__subject__isnull=False))
    elif subject_key.isdigit():
        test_papers = test_papers.filter(
            pk__in=_paper_ids_with(question__subject_id=int(subject_key)))
    if chapter_key:
        test_papers = test_papers.filter(
            pk__in=_paper_ids_with(question__chapter_id=int(chapter_key)))
    if topic_key:
        test_papers = test_papers.filter(
            pk__in=_paper_ids_with(question__knowledge_points=int(topic_key)))
    if author:
        test_papers = test_papers.filter(created_by=author)
    # 我的作答状态筛选（未登录时忽略）
    if user.is_authenticated:
        my_paper_ids = TestRecord.objects.filter(
            user=user, test_paper__isnull=False).values('test_paper_id')
        if status == 'done':
            test_papers = test_papers.filter(pk__in=my_paper_ids)
        elif status == 'undone':
            test_papers = test_papers.exclude(pk__in=my_paper_ids)
        else:
            status = 'all'
    else:
        status = 'all'
    # 注题量用于排序与展示
    test_papers = test_papers.annotate(
        question_count=Count('questions', distinct=True)
    )
    # 排序（默认按发布时间升序，先发布的先展示）
    if sort == 'score':
        test_papers = test_papers.order_by('-total_score', '-created_at')
    elif sort == 'questions':
        test_papers = test_papers.order_by('-question_count', '-created_at')
    elif sort == 'newest':
        test_papers = test_papers.order_by('-created_at')
    else:
        sort = 'oldest'
        test_papers = test_papers.order_by('created_at')

    paginated_test_papers = paginate_queryset(test_papers, request.GET.get('page', 1))

    # 分页链接的公共查询串（去掉 page，页码由模板拼接），避免模板里重复拼筛选条件
    page_params = request.GET.copy()
    page_params.pop('page', None)

    context = {
        'test_papers': paginated_test_papers,
        'search': search,
        'sort': sort,
        'status': status,
        'subject_key': subject_key,
        'chapter_key': chapter_key,
        'topic_key': topic_key,
        'author': author,
        # 分类导航三行（学科/章节/知识点）与出题人选项：计数基于可见集合
        'category_nav': _paper_category_nav(
            progress_base, subject_key, chapter_key, topic_key,
            page_params, request.path),
        'author_options': _paper_author_options(progress_base, author),
        'has_filter': bool(search or author or chapter_key or topic_key
                           or subject_key != 'all' or sort != 'oldest'
                           or status != 'all'),
        'query_string': page_params.urlencode(),
    }

    # 我的试卷完成状态：当前页批量聚合（列表区块渲染所需，AJAX 翻页同样要算）
    if user.is_authenticated:
        _annotate_my_paper_status(paginated_test_papers, user)
    # 卡片上的「学科 / 章节」徽标：同为当前页批量聚合
    _annotate_paper_categories(paginated_test_papers)

    # 列表区块的 AJAX 请求（翻页/筛选/重置）：只返回列表片段，
    # 跳过 Hero 统计/全站榜单等与列表无关的重查询
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return render(request, 'quiz/frontend/_test_paper_list_body.html', context)

    # Hero 区全站统计（公开试卷 + 公开题目，不受搜索影响）
    # P2-4：加 5 分钟 cache，避免每次列表页都 count 全表
    hero_stats = cache.get_or_set(
        'hero_stats',
        lambda: {
            'total_papers': TestPaper.objects.filter(
                is_published=True, is_public=True, is_wrong_paper=False,
                review_status=TestPaper.REVIEW_APPROVED).count(),
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
        # 错题数只统计当前错题本（已消除/已掌握的题不计入）
        context['wrong_count'] = WrongQuestion.objects.filter(user=user).exclude(review_status='mastered').count()
        context['profile'] = profile
        # 正确率：与榜单同一口径（答对题次 / 实际作答题次，未作答的题不计入分母），
        # 直接读 Profile 冗余计数，保证与正确率榜显示的数值完全一致
        context['accuracy_rate'] = accuracy_percent(profile.answered_correct, profile.answered_total)

        # 我的完成进度（可见试卷中已作答的份数）
        progress_total = progress_base.count()
        progress_done = TestRecord.objects.filter(
            user=user, test_paper__in=progress_base
        ).values('test_paper_id').distinct().count()
        context['progress_total'] = progress_total
        context['progress_done'] = progress_done
        context['progress_rate'] = int(
            progress_done * 100 / progress_total) if progress_total else 0

    # 全站排行榜（个人榜）：三个榜单各取 Top N，登录用户额外带自己的名次
    context['site_boards'] = get_site_leaderboards(user)
    context['min_answers'] = MIN_ANSWERS_FOR_ACCURACY_RANK

    return render(request, 'quiz/frontend/test_paper_list.html', context)

def _can_view_unapproved_paper(test_paper, user):
    """未审核通过的试卷（待审核/已驳回）仅创建者本人与管理员可访问。

    这类试卷不会出现在全站列表，直接凭 URL 访问也要拦住，避免绕过审核传播。
    """
    if test_paper.is_approved:
        return True
    if not user.is_authenticated:
        return False
    return test_paper.created_by == user.username or user.is_staff


def test_paper_detail(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    user = request.user
    if not test_paper.is_public and (not user.is_authenticated or (test_paper.created_by != user.username and not user.is_staff)):
        raise Http404('试卷不存在或无权访问')
    if not _can_view_unapproved_paper(test_paper, user):
        raise Http404('试卷不存在或无权访问')
    questions = list(test_paper.questions.all())
    for q in questions:
        q.options = parse_options(q.options)

    # ===== 答题草稿：继续测试时预填答案（公开试卷，is_wrong_paper=False）=====
    draft = None
    draft_answers = {}
    if user.is_authenticated:
        draft = TestDraft.objects.filter(
            user=user, test_paper=test_paper, is_wrong_paper=False).first()
        if draft:
            draft_answers = draft.answers or {}

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
        # 倒计时（草稿优先：基于数据库开始时间，断线/关闭浏览器回来不重置；无草稿回退 session）
        if not exam_block and test_paper.duration:
            elapsed = None
            if draft and draft.start_time:
                elapsed = (now - draft.start_time).total_seconds()
            else:
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
                if draft and draft.answers:
                    # 到期且草稿有答案：自动用保存的答案提交，避免中断后回来丢分
                    return _auto_submit_expired_draft(request, test_paper, draft)
                exam_block = '答题时间已到，请提交试卷'
    # ===== P2-3 END =====

    # 记录本次答题起点：仅在实际可作答时记录（未开放/已结束/次数用尽不记录），
    # 提交时据此统计答题用时（限时/不限时统一）
    if user.is_authenticated and not exam_block:
        mark_answer_start(request, 'paper_{}'.format(paper_id))

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
        'draft': draft,
        'draft_answers': draft_answers,
        'draft_save_url': reverse('save_draft', args=[paper_id]),
    })


def _auto_submit_expired_draft(request, test_paper, draft):
    """限时考试到期且草稿有答案时自动提交（计分），避免异常中断后回来丢分"""
    questions = list(test_paper.questions.all())
    user_answers = draft.answers or {}
    # 用时：草稿 start_time 优先（跨会话可靠），否则取 session 起点
    duration_seconds = resolve_duration_seconds(
        request, 'paper_{}'.format(test_paper.id), fallback_start=draft.start_time)
    test_record, score, correct_count, wrong_count, question_results = submit_paper_records(
        request.user, test_paper, questions, user_answers, duration_seconds=duration_seconds,
        hinted_question_ids=pop_hinted_question_ids(request, 'paper', test_paper.id))
    draft.delete()
    messages.info(request, '答题时间已到，已自动为您提交临时保存的答案')
    return render(request, 'quiz/frontend/test_paper_result.html', {
        'test_paper': test_paper,
        'score': score,
        'correct_count': correct_count,
        'wrong_count': wrong_count,
        'unanswered_count': count_unanswered(question_results),
        'total_count': len(question_results),
        'question_results': question_results,
        'test_record': test_record,
        'duration_display': format_duration(duration_seconds),
    })

@login_required
def submit_test_paper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    if not _can_view_unapproved_paper(test_paper, request.user):
        raise Http404('试卷不存在或无权访问')
    questions = list(test_paper.questions.all())

    if request.method == 'POST':
        # ===== 草稿：有草稿时计时以草稿 start_time 为准 =====
        draft = TestDraft.objects.filter(
            user=request.user, test_paper=test_paper, is_wrong_paper=False).first()
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
        # 限时校验：草稿计时优先，其次会话开始时间（服务端兜底，防绕过倒计时）。
        # 有草稿且超时：放行提交（对应"到期自动提交草稿"场景，避免丢分）；无草稿超时：阻断。
        if test_paper.duration:
            elapsed = None
            if draft and draft.start_time:
                elapsed = (now - draft.start_time).total_seconds()
            else:
                import time as _time
                start_ts = request.session.get('exam_start_{}'.format(paper_id))
                if start_ts:
                    try:
                        elapsed = _time.time() - float(start_ts)
                    except (TypeError, ValueError):
                        elapsed = 0
            if elapsed is not None and elapsed > test_paper.duration * 60 and not draft:
                messages.error(request, '答题时间已到，无法提交')
                return redirect('test_paper_detail', paper_id=paper_id)
        # 清除倒计时开始时间
        sess_key = 'exam_start_{}'.format(paper_id)
        if sess_key in request.session:
            del request.session[sess_key]
            request.session.modified = True
        # ===== P2-3 END =====
        user_answers = collect_user_answers(questions, request.POST)

        # 本次答题用时：草稿 start_time 优先（跨会话可靠），否则取 session 记录的起点
        duration_seconds = resolve_duration_seconds(
            request, 'paper_{}'.format(paper_id),
            fallback_start=(draft.start_time if draft else None))

        # 落库：得分 / TestRecord / AnswerRecord / 错题本 / Profile 统计（P2-2 公共函数）
        test_record, score, correct_count, wrong_count, question_results = submit_paper_records(
            request.user, test_paper, questions, user_answers,
            duration_seconds=duration_seconds,
            hinted_question_ids=pop_hinted_question_ids(request, 'paper', paper_id))

        # 提交成功，删除答题草稿
        if draft:
            draft.delete()

        return render(request, 'quiz/frontend/test_paper_result.html', {
            'test_paper': test_paper,
            'score': score,
            'correct_count': correct_count,
            'wrong_count': wrong_count,
            'unanswered_count': count_unanswered(question_results),
            'total_count': len(question_results),
            'question_results': question_results,
            'test_record': test_record,
            'duration_display': format_duration(duration_seconds),
        })
    
    for q in questions:
        q.options = parse_options(q.options)
    
    return render(request, 'quiz/frontend/test_paper_detail.html', {
        'test_paper': test_paper,
        'questions': questions
    })


@login_required
def save_draft(request, paper_id):
    """AJAX 临时保存答题草稿（公开试卷/错题组卷共用；source=paper/wrong）"""
    if request.method != 'POST':
        return JsonResponse({'success': False, 'message': '无效的请求'})
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    is_wrong_paper = request.POST.get('source') == 'wrong'
    # 权限：公开试卷所有人可答；私有/错题组卷仅创建者本人（管理员可访问私有公开试卷草稿）
    if not test_paper.is_public and (test_paper.created_by != request.user.username and not request.user.is_staff):
        return JsonResponse({'success': False, 'message': '无权访问该试卷'})
    if is_wrong_paper and test_paper.created_by != request.user.username:
        return JsonResponse({'success': False, 'message': '无权访问该试卷'})
    try:
        answers_raw = json.loads(request.POST.get('answers_json') or '{}')
    except Exception:
        answers_raw = {}
    if not isinstance(answers_raw, dict):
        answers_raw = {}
    # 清洗：仅保留当前试卷题目的答案，值为受限长度字符串
    question_ids = set(test_paper.questions.values_list('id', flat=True))
    answers = {}
    for k, v in answers_raw.items():
        if str(k).isdigit() and int(k) in question_ids and isinstance(v, str) and len(v) <= 10:
            answers[str(int(k))] = v
    try:
        current_index = int(request.POST.get('current_index', '0'))
    except (TypeError, ValueError):
        current_index = 0
    mode = request.POST.get('mode', 'full')
    if mode not in ('full', 'single'):
        mode = 'full'

    draft, created = TestDraft.objects.get_or_create(
        user=request.user, test_paper=test_paper, is_wrong_paper=is_wrong_paper,
        defaults={'answers': answers, 'current_index': current_index, 'mode': mode})
    if not created:
        draft.answers = answers
        draft.current_index = current_index
        draft.mode = mode
    # 限时考试：首次保存时记录计时起点（取 session 已流逝时间换算，保证断线/刷新不重置）
    if draft.start_time is None and test_paper.duration:
        import time as _time
        sess_start = request.session.get('exam_start_{}'.format(paper_id))
        if sess_start:
            try:
                elapsed = _time.time() - float(sess_start)
                draft.start_time = timezone.now() - timedelta(seconds=max(0, elapsed))
            except (TypeError, ValueError):
                draft.start_time = timezone.now()
        else:
            draft.start_time = timezone.now()
    draft.save()
    return JsonResponse({'success': True, 'draft_id': draft.id, 'answered_count': len(answers)})


@login_required
def discard_draft(request, draft_id):
    """放弃答题草稿（仅本人可操作）"""
    draft = get_object_or_404(TestDraft, pk=draft_id, user=request.user)
    if request.method == 'POST':
        draft.delete()
        messages.success(request, '已放弃临时保存的答题进度')
    return redirect(request.GET.get('next', 'test_history'))

@login_required
def test_history(request):
    # select_related 避免 record.test_paper 外键 N+1；annotate 一次算出 question_count（原循环 count）
    test_records = TestRecord.objects.filter(user=request.user).select_related(
        'test_paper'
    ).annotate(question_count=Count('test_paper__questions')).order_by('-completed_at')
    paginated_records = paginate_queryset(test_records, request.GET.get('page', 1), items_per_page=10)

    # 成绩等级：按试卷配置的等级线（默认及格 60%、优秀 80%）
    # 在视图算好数值再比较（模板 {% widthratio ... as x %} 存的是字符串，与数字比较恒为 False，会导致全部落到"不及格"）
    for record in paginated_records:
        record.percentage = int(round(record.score * 100 / record.total_score)) if record.total_score else 0
        paper = record.test_paper
        # test_paper 允许为空（模板同样做了判空），为空时回落到默认等级线
        excellent_line = paper.excellent_rate if paper else TestPaper.DEFAULT_EXCELLENT_RATE
        pass_line = paper.pass_rate if paper else TestPaper.DEFAULT_PASS_RATE
        if record.percentage >= excellent_line:
            record.grade, record.grade_class = '优秀', 'excellent'
        elif record.percentage >= pass_line:
            record.grade, record.grade_class = '及格', 'pass'
        else:
            record.grade, record.grade_class = '不及格', 'fail'
        # 答题用时展示文案（无记录显示 --）
        record.duration_display = format_duration(record.duration_seconds)

    # ===== 进行中的答题草稿（临时保存，支持继续测试）=====
    drafts = list(TestDraft.objects.filter(user=request.user).select_related(
        'test_paper', 'assignment', 'assignment__test_paper').order_by('-updated_at'))
    # 批量取题目总数，避免逐条 count 的 N+1
    paper_ids = [d.test_paper_id for d in drafts if d.test_paper_id]
    paper_ids += [d.assignment.test_paper_id for d in drafts if d.assignment and d.assignment.test_paper_id]
    if paper_ids:
        qc_map = dict(TestPaper.objects.filter(id__in=paper_ids).annotate(
            qc=Count('questions')).values_list('id', 'qc'))
    else:
        qc_map = {}
    now = timezone.now()
    for d in drafts:
        if d.assignment_id:
            d.title = d.assignment.title
            d.question_total = qc_map.get(d.assignment.test_paper_id, 0)
            d.continue_url = reverse('do_class_assignment', args=[d.assignment_id])
            d.remaining_seconds = None
            d.remaining_display = None
        else:
            d.title = d.test_paper.title
            d.question_total = qc_map.get(d.test_paper_id, 0)
            d.continue_url = reverse(
                'submit_wrong_question_paper' if d.is_wrong_paper else 'test_paper_detail',
                args=[d.test_paper_id])
            # 限时考试剩余时间（连续计时）
            if d.test_paper.duration and d.start_time:
                rem = max(0, int(d.test_paper.duration * 60 - (now - d.start_time).total_seconds()))
                d.remaining_seconds = rem
                d.remaining_display = '已超时' if rem <= 0 else '剩{}分{:02d}秒'.format(rem // 60, rem % 60)
            else:
                d.remaining_seconds = None
                d.remaining_display = None

    return render(request, 'quiz/frontend/test_history.html', {
        'test_records': paginated_records,
        'test_drafts': drafts,
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
        'is_assignment': is_assignment,
        'duration_display': format_duration(test_record.duration_seconds)
    })




@login_required
def wrong_question_notebook(request):
    status = request.GET.get('status', 'all')
    now = timezone.now()

    qs = WrongQuestion.objects.filter(user=request.user).select_related('question')
    # 「全部」= 当前错题本（已消除的题归入「已掌握」Tab，不再参与练习）
    if status == 'all':
        qs = qs.exclude(review_status='mastered')
    # 状态筛选：待复习 = 未复习 或 已到下次复习时间
    elif status == 'pending':
        qs = qs.filter(Q(review_status='new') | Q(next_review_at__lte=now))
    elif status in ('new', 'reviewing', 'mastered', 'difficult'):
        qs = qs.filter(review_status=status)
    qs = qs.order_by('-added_at')

    # 处理每个错题的选项字段
    for wq in qs:
        wq.question.options = parse_options(wq.question.options)

    # 每页显示题数：默认 20，用户可通过 ?page_size= 自由设置（1~100），便于控制组卷题量
    try:
        page_size = int(request.GET.get('page_size', ''))
    except (TypeError, ValueError):
        page_size = 0
    if page_size < 1 or page_size > 100:
        page_size = 20

    paginated_wrong_questions = paginate_queryset(qs, request.GET.get('page', 1), items_per_page=page_size)

    # 各复习状态统计
    # P2-8：6 次独立查询合并为 1 次 aggregate with conditional Count
    base = WrongQuestion.objects.filter(user=request.user)
    review_stats = base.aggregate(
        # total = 当前错题本数量（不含已消除的「已掌握」）
        total=models.Count('id', filter=~Q(review_status='mastered')),
        new=models.Count('id', filter=Q(review_status='new')),
        reviewing=models.Count('id', filter=Q(review_status='reviewing')),
        difficult=models.Count('id', filter=Q(review_status='difficult')),
        mastered=models.Count('id', filter=Q(review_status='mastered')),
        pending=models.Count('id', filter=Q(review_status='new') | Q(next_review_at__lte=now)),
    )
    review_stats = {k: (v or 0) for k, v in review_stats.items()}

    # 组卷额度：会员不限次数；免费用户每天有限次免费额度（后台「错题组卷额度」配置）
    # 单次超过 10 题一律需要用卡，用卡当次不限题量（与 create_wrong_question_paper 同口径）
    _paper_card, _paper_card_count = _wrong_paper_card_state(request.user)
    _is_member, _free_limit, _remaining_free = _wrong_paper_quota_state(request.user)

    return render(request, 'quiz/frontend/wrong_question_notebook.html', {
        'wrong_questions': paginated_wrong_questions,
        'status': status,
        'page_size': page_size,
        'review_stats': review_stats,
        'mastery_streak_required': MASTERY_STREAK_REQUIRED,
        # 列表里的连对进度圆点：range(2) -> [0, 1]
        'mastery_streak_range': range(MASTERY_STREAK_REQUIRED),
        'wrong_paper_free_limit': WRONG_PAPER_FREE_LIMIT,
        'wrong_paper_card_count': _paper_card_count,
        # 组卷卡道具本体：前台按道具本名/图标展示（后台改名后自动跟随）
        'wrong_paper_card': _paper_card,
        # 组卷额度：会员不限次数；免费用户显示今日剩余/每日上限（剩余 -1 = 不限）
        'wrong_paper_is_member': _is_member,
        'wrong_paper_free_daily_limit': _free_limit,
        'wrong_paper_remaining_free': _remaining_free,
    })

@login_required
def wrong_question_review(request, wrong_question_id):
    """错题状态操作：
    - mastered：手动标记已掌握（移出错题本练习池）
    - restore：从「已掌握」恢复到错题本复习池（连对次数清零）
    - reviewing：记录一次复习（间隔重复算法）
    """
    if request.method != 'POST':
        return redirect('wrong_question_notebook')
    wq = get_object_or_404(WrongQuestion, id=wrong_question_id, user=request.user)
    action = request.POST.get('action', 'reviewing')
    if action == 'mastered':
        wq.review_status = 'mastered'
        wq.correct_streak = MASTERY_STREAK_REQUIRED
        wq.next_review_at = None
        wq.last_reviewed_at = timezone.now()
        wq.save()
        messages.success(request, '已标记为「已掌握」，已移出错题本 🎯')
    elif action == 'restore':
        wq.review_status = 'reviewing'
        wq.correct_streak = 0
        wq.next_review_at = None
        wq.last_reviewed_at = timezone.now()
        wq.save()
        messages.success(request, '已恢复到错题本，连续答对次数已清零 ↩️')
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

        # 需要用卡的两种情形（服务端校验，防构造请求绕过）：
        # 1) 单次选题超过 10 题；2) 免费用户的每日免费次数已用完
        card, card_count = _wrong_paper_card_state(request.user)
        # 文案用道具本名（如「回响之杖」）而非功能名，后台改名后前台自动跟随
        card_label = f'「{card.name}」' if card else '组卷卡'
        is_member, free_limit, remaining_free = _wrong_paper_quota_state(request.user)
        no_free_quota_left = (not is_member) and remaining_free <= 0
        need_card = len(selected_ids) > WRONG_PAPER_FREE_LIMIT or no_free_quota_left
        use_card = False
        if need_card:
            if card is None or card_count <= 0:
                reasons = []
                if no_free_quota_left:
                    reasons.append(f'今日免费组卷次数已用完（免费用户每天 {free_limit} 次）')
                if len(selected_ids) > WRONG_PAPER_FREE_LIMIT:
                    reasons.append(f'组卷单次最多 {WRONG_PAPER_FREE_LIMIT} 题')
                messages.error(
                    request,
                    f'{"；".join(reasons)}，使用{card_label}可继续组卷且当次不限题量，可在道具商城兑换。')
                return redirect('wrong_question_notebook')
            use_card = True

        # 创建试卷
        test_paper = TestPaper.objects.create(
            title='错题巩固试卷',
            description='错题巩固试卷',
            created_by=request.user.username,
            is_published=False,
            # 打标：不进入后台试卷列表、作业选题列表与「我的试卷」管理
            is_wrong_paper=True
        )
        
        # 一次查询所有题目（原逐题 get，N+1）；m2m_changed 自动更新 total_score，无需手动算
        questions = list(Question.objects.filter(id__in=selected_ids))
        test_paper.questions.set(questions)

        if use_card:
            from starcoin.services import consume_item
            consume_item(request.user, card, context='wrong_paper',
                         detail=f'错题组卷 {len(questions)} 题')

        return redirect('submit_wrong_question_paper', paper_id=test_paper.id)
    
    # GET请求时重定向到错题本选择页面
    return redirect('wrong_question_notebook')

@login_required
def submit_wrong_question_paper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    questions = list(test_paper.questions.all())

    # ===== 错题组卷草稿：继续测试时预填 =====
    draft = TestDraft.objects.filter(
        user=request.user, test_paper=test_paper, is_wrong_paper=True).first()
    draft_answers = (draft.answers or {}) if draft else {}

    if request.method != 'POST':
        # 记录本次答题起点：提交时据此统计答题用时
        mark_answer_start(request, 'paper_{}'.format(paper_id))

    if request.method == 'POST':
        user_answers = collect_user_answers(questions, request.POST)

        # 本次答题用时：草稿 start_time 优先（跨会话可靠），否则取 session 记录的起点
        duration_seconds = resolve_duration_seconds(
            request, 'paper_{}'.format(paper_id),
            fallback_start=(draft.start_time if draft else None))

        # 本次答题中手动勾选「保留」的题目：本次不消除，连对次数清零（仅本次有效）
        kept_question_ids = {
            q.id for q in questions if request.POST.get(f'keep_question_{q.id}')
        }

        score, correct_count, wrong_count, total_count, question_results = calculate_score(questions, user_answers)

        # 创建答题记录 + 答案记录（P2-2 公共函数）
        test_record, _wrong_questions_list = create_test_and_answer_records(
            request.user, test_paper, questions, score, question_results,
            is_wrong_paper=True, duration_seconds=duration_seconds)

        # 错题本消除机制：连对 2 次才消除（答错 -1），手动保留的题本次不消除
        summary = update_wrong_question_notebook(
            request.user, question_results, kept_question_ids,
            hinted_question_ids=pop_hinted_question_ids(request, 'wrong', paper_id))

        # 榜单统计（得分 / 斩题数 / 作答题次）：错题巩固同样是刷题，必须与试卷口径一致累加
        update_profile_leaderboard_stats(request.user, score, question_results)

        # 提交成功，删除错题组卷草稿
        if draft:
            draft.delete()

        return render(request, 'quiz/frontend/wrong_question_paper_result.html', {
            'test_paper': test_paper,
            'score': score,
            'correct_count': correct_count,
            'wrong_count': wrong_count,
            'unanswered_count': count_unanswered(question_results),
            'total_count': total_count,
            'question_results': question_results,
            'test_record': test_record,
            'duration_display': format_duration(duration_seconds),
            'mastered_questions': summary['mastered'],
            'kept_questions': summary['kept'],
            'streak_up_questions': summary['streak_up'],
            'mastery_streak_required': MASTERY_STREAK_REQUIRED,
        })

    # 复习进度（连对次数）用于答题页提示：再答对即消除
    streaks = dict(WrongQuestion.objects.filter(
        user=request.user, question__in=questions).values_list('question_id', 'correct_streak'))
    for q in questions:
        q.options = parse_options(q.options)
        q.correct_streak = streaks.get(q.id, 0)

    return render(request, 'quiz/frontend/wrong_question_paper.html', {
        'test_paper': test_paper,
        'questions': questions,
        'total_score': test_paper.total_score,
        'draft': draft,
        'draft_answers': draft_answers,
        'draft_save_url': reverse('save_draft', args=[paper_id]),
        'mastery_streak_required': MASTERY_STREAK_REQUIRED,
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
    # 错题组卷试卷不进入「我的试卷」管理列表（由错题本功能内部维护）
    base_qs = TestPaper.objects.filter(
        created_by=user.username, is_wrong_paper=False
    ).annotate(
        question_count=models.Count('questions')
    )

    # 搜索：标题
    q = request.GET.get('q', '').strip()
    if q:
        base_qs = base_qs.filter(title__icontains=q)

    # 筛选：状态（published/unpublished/pending/rejected/exam）
    status = request.GET.get('status', '')
    if status == 'published':
        base_qs = base_qs.filter(is_published=True, review_status=TestPaper.REVIEW_APPROVED)
    elif status == 'unpublished':
        # 未发布 = 不是「已上架」也不是已驳回的草稿（与统计口径一致，避免与待审核/已驳回重复）
        base_qs = base_qs.filter(is_published=False,
                                 review_status=TestPaper.REVIEW_APPROVED)
    elif status == 'pending':
        base_qs = base_qs.filter(review_status=TestPaper.REVIEW_PENDING)
    elif status == 'rejected':
        base_qs = base_qs.filter(review_status=TestPaper.REVIEW_REJECTED)
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
    # 「已发布」只算已上架（审核通过）的；待审核/已驳回单独计数，三者互不重叠
    stats = TestPaper.objects.filter(
        created_by=user.username, is_wrong_paper=False).aggregate(
        total=models.Count('id'),
        published=models.Count('id', filter=models.Q(
            is_published=True, review_status=TestPaper.REVIEW_APPROVED)),
        pending=models.Count('id', filter=models.Q(
            review_status=TestPaper.REVIEW_PENDING)),
        unpublished=models.Count('id', filter=(
            models.Q(is_published=False, review_status=TestPaper.REVIEW_APPROVED) |
            models.Q(review_status=TestPaper.REVIEW_REJECTED)
        )),
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

def _notify_paper_submitted(test_paper, user):
    """前台试卷提交发布后，通知后台管理员前往审核"""
    Notification.notify_many(
        recipients=User.objects.filter(is_staff=True, is_active=True),
        sender=user,
        ntype='system',
        title=f'试卷待审核：{test_paper.title}',
        content=f'用户 {user.username} 提交了试卷「{test_paper.title}」，请前往后台试卷管理审核。',
        link='/admin/quiz/testpaper/?review_status__exact=0',
    )


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
            test_paper = TestPaper(
                title=title,
                description=description,
                created_by=request.user.username,
                is_published=is_published,
                duration=int(duration) if duration and duration.isdigit() else None,
                max_attempts=int(max_attempts) if max_attempts and max_attempts.isdigit() else None,
                start_time=start_time,
                end_time=end_time,
            )
            if is_published:
                # 前台发布需管理员审核，审核通过后才进入全站列表
                test_paper.submit_for_review()
            test_paper.save()
            # ===== P2-3 END =====

            # 一次查询所有题目（原逐题 get，N+1）；m2m_changed 自动更新 total_score
            questions = list(Question.objects.filter(id__in=question_ids))
            test_paper.questions.set(questions)
            total_score = sum(q.score for q in questions)

            messages.success(
                request,
                f'试卷 "{title}" 创建成功！共 {len(questions)} 道题目，总分 {total_score} 分。'
                + ('已提交管理员审核，审核通过后将展示到全站试卷列表。' if is_published else ''))
            if is_published:
                _notify_paper_submitted(test_paper, request.user)
            return redirect('my_test_papers')
        else:
            messages.error(request, '请填写试卷标题并至少选择一道题目')

    context = _paper_editor_context(request)
    ajax_response = _paper_editor_ajax_response(
        request, context, 'quiz/frontend/_editor_questions.html')
    if ajax_response:
        return ajax_response
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
        'display_title': ch.display_title,
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

    # 本次随机抽中的题目（AJAX 局部刷新时前端直接并入已选，无需整页 redirect）
    random_picked = [{
        'id': q.id, 'content': q.content, 'score': q.score, 'type': q.type
    } for q in random_questions]

    # 随机选中的题目并入已选（整页渲染时 JS 直接构造 selectedQuestions）
    sel_questions += random_picked

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
        'random_questions': random_picked,
        'redirect_url': redirect_url,
    }


def _paper_editor_ajax_response(request, context, template):
    """组卷页局部刷新（翻页/筛选/随机选题）：返回题目列表片段 + 随机结果 JSON。

    非 AJAX 请求返回 None，由调用方按整页渲染处理；
    这样翻页不会整页重载，表单里已填的试卷标题/描述不会被清空。
    """
    if request.headers.get('X-Requested-With') != 'XMLHttpRequest':
        return None
    return JsonResponse({
        'html': render_to_string(template, context, request=request),
        'total': context['question_total'],
        'page': context['page_obj'].number,
        'random': context['random_questions'],
    })


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
            was_published = test_paper.is_published
            test_paper.is_published = request.POST.get('is_published') == 'on'
            # 由「未发布」变为发布：重新提交管理员审核
            submitted = test_paper.is_published and not was_published
            if submitted:
                test_paper.submit_for_review()
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
                f'试卷 "{title}" 已更新！共 {len(questions)} 道题目，总分 {total_score} 分。'
                + ('已提交管理员审核，审核通过后将展示到全站试卷列表。' if submitted else ''))
            if submitted:
                _notify_paper_submitted(test_paper, request.user)
            return redirect('my_test_papers')
        else:
            messages.error(request, '请填写试卷标题并至少选择一道题目')

    context = _paper_editor_context(request, test_paper=test_paper)
    context.update({
        'edit_mode': True,
        'test_paper': test_paper,
        'ps_pub': 'true' if test_paper.is_published else 'false',
    })
    ajax_response = _paper_editor_ajax_response(
        request, context, 'quiz/frontend/_editor_questions.html')
    if ajax_response:
        return ajax_response
    if context.get('redirect_url'):
        return redirect(request.path + context['redirect_url'])
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
        if test_paper.is_published:
            # 前台发布需管理员审核：进入待审核，审核通过后才会展示到全站列表
            test_paper.submit_for_review()
            test_paper.save()
            messages.success(request, f'试卷 "{test_paper.title}" 已提交发布，等待管理员审核通过后展示到全站')
            _notify_paper_submitted(test_paper, request.user)
        else:
            # 取消发布时撤回待审核状态，回到普通「未发布」草稿（审核队列中不再保留）
            if test_paper.is_review_pending:
                test_paper.review_status = TestPaper.REVIEW_APPROVED
                test_paper.reviewed_at = None
                test_paper.reviewed_by = None
            test_paper.save()
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

