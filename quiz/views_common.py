from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db import models
from django.db.models import Count, ExpressionWrapper, F, FloatField, Max, Q, Sum  # P2-1 拆分后各子模块经 common 复用
from django.http import HttpResponse, Http404, JsonResponse
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib import messages
from django.db import IntegrityError, transaction
from django.contrib.auth.models import User
import json
from datetime import timedelta


class BaseTestPaperImporter:
    """试卷导入基类 - 包含前后台共同的导入逻辑"""
    
    def __init__(self, request, template_name, success_redirect, created_by='admin', is_public=True, default_is_published=False, duplicate_scope=None):
        self.request = request
        self.template_name = template_name
        self.success_redirect = success_redirect
        self.created_by = created_by
        self.is_public = is_public
        self.default_is_published = default_is_published
        self.duplicate_scope = duplicate_scope  # 防重复作用域：None=不启用；字符串=按该维度（如用户名）
    
    def get_created_by(self):
        """获取创建者 - 子类可覆盖"""
        return self.created_by
    
    def get_is_public(self):
        """获取题目是否公开 - 子类可覆盖"""
        return self.is_public
    
    def get_is_published(self, request):
        """获取试卷是否发布 - 子类可覆盖"""
        if hasattr(request, 'POST'):
            return request.POST.get('is_published') == 'on'
        return self.default_is_published
    
    def get_success_redirect(self, test_paper):
        """获取成功重定向 - 子类可覆盖"""
        return self.success_redirect
    
    def mark_duplicate_imported(self, count):
        """导入成功后记录文件 hash，用于防重复导入（未启用时直接跳过）"""
        if self.duplicate_scope is None:
            return
        file_hash = self.request.session.pop('import_file_hash', None)
        if file_hash:
            mark_imported(file_hash, count, scope=self.duplicate_scope)
    
    @transaction.atomic
    def process_confirm_import(self):
        """处理确认导入"""
        title = self.request.POST.get('title', '导入试卷')
        description = self.request.POST.get('description', '')
        is_published = self.get_is_published(self.request)
        questions_json = self.request.POST.get('questions_json', '')
        
        if not questions_json:
            messages.error(self.request, '没有题目数据，请重新上传文件')
            return render(self.request, self.template_name, {'step': 1})
        
        try:
            questions_data = json.loads(questions_json)
            test_paper = TestPaper.objects.create(
                title=title,
                description=description,
                created_by=self.get_created_by(),
                is_published=is_published
            )
            
            total_score = 0
            valid_count = 0
            for q_data in questions_data:
                # 复用公共建题函数（含 Subject/Chapter/KP get_or_create 与安全清洗）
                question = create_question_from_data(
                    q_data, self.get_is_public(), self.get_created_by())
                if question is None:
                    continue
                test_paper.questions.add(question)
                total_score += question.score
                valid_count += 1
            
            test_paper.total_score = total_score
            test_paper.save()
            
            self.mark_duplicate_imported(valid_count)
            
            if self.get_is_public():
                tip = '题目已加入共享题库，可在组卷时选用。'
            else:
                tip = '题目已保存到我的题库，可在创建试卷时复用组卷。'
            messages.success(self.request, f'试卷 "{title}" 导入成功！共导入 {valid_count} 道题目，总分 {total_score} 分。{tip}')
            return self.get_success_redirect(test_paper)
        except Exception as e:
            transaction.set_rollback(True)  # 异常时回滚已创建的 TestPaper/Question，避免脏数据残留
            messages.error(self.request, f'导入失败：{str(e)}')
            return render(self.request, self.template_name, {'step': 1})
    
    def process_file_upload(self):
        """处理文件上传"""
        title = self.request.POST.get('title', '导入试卷')
        description = self.request.POST.get('description', '')
        
        try:
            file = self.request.FILES['file']
            file_content = file.read()
            file.seek(0)
            
            # 统一防重复（duplicate_scope 非 None 时启用，按 scope 维度隔离，如用户名）
            if self.duplicate_scope is not None:
                is_dup, prev_count, import_time = is_duplicate_import(
                    file_content, scope=self.duplicate_scope)
                if is_dup:
                    messages.error(self.request,
                        f'检测到重复导入！该文件已于 {import_time.strftime("%Y-%m-%d %H:%M")} 导入，'
                        f'共导入 {prev_count} 道题目。如需重新导入，请等待24小时或修改文件内容后重试。')
                    return render(self.request, self.template_name, {'step': 1})
                self.request.session['import_file_hash'] = generate_file_hash(file_content)
            
            questions_data, stats, errors = import_questions_from_excel(file)
            
            if errors:
                messages.error(self.request, errors[0])
                return render(self.request, self.template_name, {'step': 1})
            
            for idx, q in enumerate(questions_data):
                q['row'] = idx + 2
                q['has_error'] = not (q.get('correct_answer') and q.get('score'))
            
            total_score = stats['total_score']
            valid_count = stats['valid_count']
            missing_count = stats['missing_count']
            
            return render(self.request, self.template_name, {
                'step': 2,
                'questions_data': questions_data,
                'questions_json': json.dumps(questions_data, ensure_ascii=False),
                'total_score': total_score,
                'valid_count': valid_count,
                'missing_count': missing_count,
                'errors': errors,
                'title': title,
                'description': description
            })
        except Exception as e:
            messages.error(self.request, f'读取文件失败：{str(e)}')
            return render(self.request, self.template_name, {'step': 1})
    
    def handle(self):
        """主处理函数"""
        if self.request.method == 'POST':
            if self.request.POST.get('action') == 'confirm_import':
                return self.process_confirm_import()
            elif self.request.POST.get('action') == 'back':
                return render(self.request, self.template_name, {'step': 1})
            elif self.request.FILES.get('file'):
                return self.process_file_upload()
        
        return render(self.request, self.template_name, {'step': 1})


class FrontendTestPaperImporter(BaseTestPaperImporter):
    """前台试卷导入器"""
    
    def __init__(self, request):
        super().__init__(
            request=request,
            template_name='quiz/frontend/import_test_paper.html',
            success_redirect='my_test_papers',
            created_by=request.user.username,
            is_public=False,
            default_is_published=False,
            duplicate_scope=request.user.username  # 防重复按用户隔离
        )
    
    def get_success_redirect(self, test_paper):
        return redirect('my_test_papers')


class AdminTestPaperImporter(BaseTestPaperImporter):
    """后台试卷导入器"""
    
    def __init__(self, request):
        super().__init__(
            request=request,
            template_name='quiz/admin/import_testpaper.html',
            success_redirect='admin_preview_testpaper',
            created_by='admin',
            is_public=True,
            default_is_published=False,
            duplicate_scope='admin'  # 后台导入试卷防重复（全局管理员维度）
        )
    
    def get_success_redirect(self, test_paper):
        return redirect('admin_preview_testpaper', paper_id=test_paper.id)
from django.utils import timezone
from django.urls import reverse
from django.contrib.sessions.models import Session
from .models import Question, TestPaper, Profile, TestRecord, AnswerRecord, WrongQuestion, ConqueredQuestion, Class, ClassAdmin, ClassApplication, ClassAssignment, ClassAssignmentRecord, Subject, Chapter, Section, KnowledgePoint, Notification, TestDraft, SiteConfig, MASTERY_STREAK_REQUIRED, MIN_ANSWERS_FOR_ACCURACY_RANK, strip_sequence_prefix
from .utils import paginate_queryset, compare_answers, calculate_score, parse_datetime_local, download_template_response, import_questions_from_excel, parse_options, share_site_url, render_leaderboard_share_image, leaderboard_share_response
from .captcha import generate_captcha_text, generate_captcha_image
import datetime
import json
import re
import time
import hashlib
from django.core.cache import cache

# P1-3：导入文件防重复缓存迁移到 Django cache 后端
# 原内存字典 _imported_files_cache 在多 worker（waitress）下进程间不共享，会失效；
# 改用 cache 后端（默认 LocMemCache，生产可换 Redis），key 带前缀，TTL=24h
IMPORTED_FILE_CACHE_PREFIX = 'imported_file_hash:'


def generate_file_hash(file_content):
    return hashlib.md5(file_content).hexdigest()


def _import_cache_key(file_hash, scope=''):
    """构造防重复缓存 key：无 scope 时保持旧格式（全局）"""
    return IMPORTED_FILE_CACHE_PREFIX + (scope + ':' if scope else '') + file_hash


def mark_imported(file_hash, imported_count, scope=''):
    """导入成功后写入防重复缓存（TTL=24h，与防重复窗口一致）"""
    cache.set(
        _import_cache_key(file_hash, scope),
        (timezone.now(), imported_count),
        24 * 3600,
    )


def is_duplicate_import(file_content, window_hours=24, scope=''):
    """检测文件是否在 window_hours 内重复导入。
    返回 (is_dup, prev_count, import_time)。
    scope：隔离维度（如用户名），空串表示全局。
    """
    file_hash = generate_file_hash(file_content)
    cache_key = _import_cache_key(file_hash, scope)
    cached = cache.get(cache_key)
    if cached:
        import_time, imported_count = cached
        time_diff = timezone.now() - import_time
        if time_diff.total_seconds() < window_hours * 3600:
            return True, imported_count, import_time
    return False, 0, None

def get_visible_questions(user):
    """获取用户可见的题目：公开题目 + 用户自己创建的私有题目"""
    if user.is_staff:
        return Question.objects.all()
    return Question.objects.filter(
        models.Q(is_public=True) | models.Q(created_by=user.username)
    )


# ===== 导入建题公共函数 =====
# 前台导入试卷、后台导入试卷、后台导入题库三处共用：
# 把单条导入数据创建为 Question，并清洗危险 HTML 内容。


def sanitize_question_text(text):
    """清洗题目文本中的危险内容：
    删除 script/style 块、on* 事件属性、javascript: 伪协议。"""
    if not text:
        return text
    text = re.sub(r'<(script|style)[^>]*>.*?</\1>', '', text, flags=re.S | re.I)
    text = re.sub(r'\son\w+\s*=\s*("[^"]*"|\'[^\']*\'|[^\s>]+)', '', text, flags=re.I)
    text = re.sub(r'javascript:', '', text, flags=re.I)
    return text.strip()


def create_question_from_data(q_data, is_public, created_by):
    """从导入数据创建一道题目（自动 get_or_create 科目/章节/小节/知识点）。
    返回 Question；数据无效（缺内容或正确答案）时返回 None。
    """
    if not q_data.get('content') or not q_data.get('correct_answer'):
        return None

    options_data = q_data.get('options', {})
    if isinstance(options_data, str):
        try:
            options_data = json.loads(options_data)
        except Exception:
            options_data = {}

    q_type = int(q_data.get('type', 1))
    if q_type not in [1, 2, 3]:
        q_type = 1

    q_score = q_data.get('score', 1)
    try:
        q_score = int(q_score) if q_score else 1
    except Exception:
        q_score = 1

    subject_obj = None
    chapter_obj = None
    section_obj = None
    kp_objects = []

    subject_name = (q_data.get('subject_name') or '').strip()
    chapter_title = (q_data.get('chapter_title') or '').strip()
    section_title = (q_data.get('section_title') or '').strip()
    kp_names = (q_data.get('knowledge_points_str') or '').strip()

    if subject_name:
        subject_obj, _ = Subject.objects.get_or_create(
            name=subject_name,
            defaults={'code': subject_name[:10].upper(), 'icon': '📚'}
        )
    if subject_obj and chapter_title:
        # 章节按「去掉第X章前缀」后的名字查重，避免同一章因导入时带/不带序号前缀被重复创建
        chapter_key = strip_sequence_prefix(chapter_title)
        chapter_obj = next(
            (c for c in Chapter.objects.filter(subject=subject_obj) if strip_sequence_prefix(c.title) == chapter_key),
            None
        )
        if chapter_obj is None:
            chapter_obj = Chapter.objects.create(
                subject=subject_obj,
                title=chapter_title,
                number=(Chapter.objects.filter(subject=subject_obj).aggregate(Max('number'))['number__max'] or 0) + 1
            )
    if chapter_obj and section_title:
        # 小节同理：章节内按去掉序号前缀后的名字查重
        section_key = strip_sequence_prefix(section_title)
        section_obj = next(
            (s for s in Section.objects.filter(chapter=chapter_obj) if strip_sequence_prefix(s.title) == section_key),
            None
        )
        if section_obj is None:
            section_obj = Section.objects.create(
                chapter=chapter_obj,
                title=section_title,
                number=(Section.objects.filter(chapter=chapter_obj).aggregate(Max('number'))['number__max'] or 0) + 1
            )
    if kp_names and subject_obj:
        for kp_name in kp_names.split(','):
            kp_name = kp_name.strip()
            if kp_name:
                kp, _ = KnowledgePoint.objects.get_or_create(
                    subject=subject_obj,
                    name=kp_name,
                    defaults={'section': section_obj}
                )
                kp_objects.append(kp)

    question = Question.objects.create(
        type=q_type,
        content=sanitize_question_text(q_data['content']),
        options=options_data,
        correct_answer=q_data['correct_answer'],
        score=q_score,
        explanation=sanitize_question_text(q_data.get('explanation', '')),
        subject=subject_obj,
        chapter=chapter_obj,
        section=section_obj,
        is_public=is_public,
        created_by=created_by
    )
    if kp_objects:
        question.knowledge_points.set(kp_objects)
    return question


# ===== P2-2 答题提交公共函数 =====
# 原 submit_test_paper / submit_wrong_question_paper / do_class_assignment /
# submit_class_assignment 四处重复"收集答案→计算分数→创建 TestRecord→创建 AnswerRecord"，
# 提取为以下两个 helper（放 common，供 views_paper / views_class 复用），
# 各提交视图仅保留自身特有逻辑（错题本、班级记录、Profile 统计等）。


def collect_user_answers(questions, post_data):
    """从 POST 数据收集用户答案（单选/多选），返回 {question_id: answer_str}"""
    user_answers = {}
    for q in questions:
        if q.type == 2:  # 多选题
            selected_options = []
            for opt in ['A', 'B', 'C', 'D']:
                if f'question_{q.id}_{opt}' in post_data:
                    selected_options.append(opt)
            if selected_options:
                user_answers[q.id] = ''.join(sorted(selected_options))
        else:
            answer_key = f'question_{q.id}'
            if answer_key in post_data:
                user_answers[q.id] = post_data[answer_key]
    return user_answers


def count_unanswered(question_results):
    """本次未作答的题数。

    未作答既不算对也不算错：不计入正确率分母、不进错题本，仅在结果页单独展示。
    """
    return sum(1 for r in question_results if not r.get('user_answer'))


def create_test_and_answer_records(user, test_paper, questions, score, question_results, is_wrong_paper=False, duration_seconds=None):
    """创建 TestRecord + 全部 AnswerRecord（bulk_create 一次插入），
    返回 (test_record, wrong_questions)。
    wrong_questions 为本次「已作答且答错」的 question 列表，供调用方处理错题本。
    duration_seconds 为本次答题用时（秒），无法确定时传 None。
    """
    test_record = TestRecord.objects.create(
        user=user,
        test_paper=test_paper,
        score=score,
        total_score=test_paper.total_score,
        completed_at=timezone.now(),
        is_wrong_paper=is_wrong_paper,
        duration_seconds=duration_seconds,
    )
    answer_records = []
    wrong_questions = []
    for result in question_results:
        question = result['question']
        options_data = parse_options(question.options)
        answer_records.append(AnswerRecord(
            test_record=test_record,
            question=question,
            user_answer=result.get('user_answer', ''),
            correct_answer=result['correct_answer'],
            is_correct=result['is_correct'],
            original_question_content=question.content,
            original_question_type=question.type,
            original_options=options_data,
            original_explanation=question.explanation,
        ))
        # 未作答的题不进错题本（既不算对也不算错）
        if not result['is_correct'] and result.get('user_answer'):
            wrong_questions.append(question)
    AnswerRecord.objects.bulk_create(answer_records)
    return test_record, wrong_questions


def update_wrong_question_notebook(user, question_results, kept_question_ids=frozenset(),
                                   hinted_question_ids=frozenset()):
    """按本次答题结果维护错题本（消除机制）：
    - 答错：连续答对次数 -1（最低 0），题目留在错题本；已掌握的题答错则退回错题本；
    - 答对且本次勾选「保留」：连对次数归零（视为还没掌握），题目保留；
    - 答对：连对次数 +1，累计到 MASTERY_STREAK_REQUIRED 次才标记「已掌握」移出错题本，防止蒙对假掌握；
    - 答对且本题本轮用过提示卡（hinted_question_ids）：视为并非真正掌握，
      直接以「已掌握」状态记入错题本留痕（不计入当前错题本），避免不会的题被漏掉；
    - 未作答：既不算对也不算错，不新增错题，也不扣已有错题的连对进度。
    kept_question_ids 为本次答题页手动勾选「保留」的题目 id 集合（仅本次有效）。
    hinted_question_ids 为本轮答题中使用过提示卡的题目 id 集合（仅本轮有效）。
    返回 summary：{'mastered': [...], 'hinted': [...], 'kept': [...], 'streak_up': [...], 're_added': [...]}，
    mastered 供结果页弹框展示并提供一键恢复。
    """
    kept_question_ids = set(kept_question_ids or ())
    hinted_question_ids = set(hinted_question_ids or ())
    question_ids = [r['question'].id for r in question_results]
    existing = {
        wq.question_id: wq
        for wq in WrongQuestion.objects.filter(user=user, question_id__in=question_ids)
    }
    now = timezone.now()
    summary = {'mastered': [], 'hinted': [], 'kept': [], 'streak_up': [], 're_added': []}

    for result in question_results:
        question = result['question']
        wq = existing.get(question.id)

        # 未作答：既不算对也不算错，不新增错题，也不扣已有错题的连对进度
        if not result.get('user_answer'):
            continue

        if not result['is_correct']:
            # 答错：新增错题，或把已有错题的连对进度扣 1
            if wq is None:
                wq = WrongQuestion.objects.create(
                    user=user,
                    question=question,
                    user_answer=result.get('user_answer') or '',
                    correct_answer=result['correct_answer'],
                )
                summary['re_added'].append(wq)
            else:
                wq.user_answer = result.get('user_answer') or ''
                wq.correct_answer = result['correct_answer']
                wq.correct_streak = max(0, wq.correct_streak - 1)
                fields = ['user_answer', 'correct_answer', 'correct_streak']
                if wq.review_status == 'mastered':
                    # 已消除的题又答错，说明没真正掌握，退回错题本
                    wq.review_status = 'reviewing'
                    wq.next_review_at = None
                    fields += ['review_status', 'next_review_at']
                wq.save(update_fields=fields)
            continue

        # 答对：只有已在错题本中的题才需要更新掌握进度
        if wq is None:
            # 本轮用过提示卡的题：答对也不代表真会，以「已掌握」状态入库留痕
            # （已掌握不计入当前错题本，但可在错题本「已掌握」Tab 里查到，不会凭空消失）
            if question.id in hinted_question_ids:
                wq = WrongQuestion.objects.create(
                    user=user,
                    question=question,
                    user_answer=result.get('user_answer') or '',
                    correct_answer=result['correct_answer'],
                    review_status='mastered',
                    correct_streak=MASTERY_STREAK_REQUIRED,
                    last_reviewed_at=now,
                )
                summary['hinted'].append(wq)
            continue

        if question.id in kept_question_ids:
            # 手动保留：本次不消除，连对进度清零
            wq.correct_streak = 0
            fields = ['correct_streak']
            if wq.review_status == 'mastered':
                wq.review_status = 'reviewing'
                wq.next_review_at = None
                fields += ['review_status', 'next_review_at']
            wq.save(update_fields=fields)
            summary['kept'].append(wq)
            continue

        wq.correct_streak += 1
        fields = ['correct_streak', 'last_reviewed_at']
        wq.last_reviewed_at = now
        if wq.correct_streak >= MASTERY_STREAK_REQUIRED:
            wq.review_status = 'mastered'
            wq.next_review_at = None
            fields += ['review_status', 'next_review_at']
            summary['mastered'].append(wq)
        else:
            summary['streak_up'].append(wq)
        wq.save(update_fields=fields)

    return summary


# ===== 答题用时统计公共函数 =====
# 设计：进入答题页时无条件写入 session 开始时间戳（取最早值，重复进入不重置），
# 提交时以「提交时间 - 起点」得到本次总用时（含中途中断/切页时间），写入 TestRecord.duration_seconds。
# 有草稿/作业记录时可用其 start_time 作为跨会话的兜底起点。

# 超过该时长的用时视为无效（如跨天挂机），不记录，避免污染统计
MAX_REASONABLE_DURATION_SECONDS = 24 * 3600
_ANSWER_START_PREFIX = 'answer_start_'


def mark_answer_start(request, key):
    """记录答题开始时间戳到 session（取最早值，同一场答题重复进入不重置）。
    key 建议用 'paper_{id}' / 'assign_{id}' 区分不同答题入口。
    """
    sess_key = _ANSWER_START_PREFIX + key
    if not request.session.get(sess_key):
        request.session[sess_key] = time.time()
        request.session.modified = True


def resolve_duration_seconds(request, key, fallback_start=None):
    """计算本次答题用时（秒）。
    起点优先取 fallback_start（草稿/作业记录的 start_time，可跨会话恢复），
    否则取 session 中 mark_answer_start 记录的时间戳。
    计算后清除 session 起点，避免多次答题（max_attempts）串用同一起点。
    无有效起点或超出合理上限时返回 None。
    """
    sess_key = _ANSWER_START_PREFIX + key
    session_start = request.session.pop(sess_key, None)

    if fallback_start:
        elapsed = (timezone.now() - fallback_start).total_seconds()
    elif session_start:
        try:
            elapsed = time.time() - float(session_start)
        except (TypeError, ValueError):
            elapsed = None
    else:
        elapsed = None

    if elapsed is None or elapsed < 0 or elapsed > MAX_REASONABLE_DURATION_SECONDS:
        return None
    return int(elapsed)


# ===== 提示卡使用留痕（仅本轮答题有效） =====
# 提示卡在答题页被使用后，把题目 id 记入 session；提交时取出并清除。
# 用途：本轮用过提示卡且答对的题，说明并非真正掌握，直接记入错题本「已掌握」池留痕，
# 否则「不会的题靠提示卡答对」会从错题本里彻底消失（既不算错题、也不留任何记录）。
# 按 source + ref 隔离，避免同一用户的多份试卷/作业之间串用。
_HINTED_QUESTIONS_PREFIX = 'hinted_questions_'


def _hinted_session_key(source, ref_id):
    return f'{_HINTED_QUESTIONS_PREFIX}{source}_{ref_id}'


def mark_hint_used(request, source, ref_id, question_id):
    """记录「本场答题中该题用过提示卡」（session 内按题目去重）"""
    key = _hinted_session_key(source, ref_id)
    ids = request.session.get(key) or []
    if question_id not in ids:
        ids.append(question_id)
        request.session[key] = ids
        request.session.modified = True


def pop_hinted_question_ids(request, source, ref_id):
    """取出并清除本场答题用过提示卡的题目 id 集合（提交时调用一次）"""
    return set(request.session.pop(_hinted_session_key(source, ref_id), None) or [])


def format_duration(seconds):
    """秒 → 可读用时文案（如 95 → '1分35秒'，120 → '2分'）；无效值返回 None。"""
    if seconds is None:
        return None
    try:
        seconds = int(seconds)
    except (TypeError, ValueError):
        return None
    if seconds < 0 or seconds > MAX_REASONABLE_DURATION_SECONDS:
        return None
    if seconds < 60:
        return f'{seconds}秒'
    minutes, sec = divmod(seconds, 60)
    return f'{minutes}分{sec}秒' if sec else f'{minutes}分'


def update_profile_leaderboard_stats(user, score, question_results):
    """把一次作答累计进 Profile 的榜单冗余计数（得分 / 斩题数 / 作答题次与答对题次）。

    正确率统一口径：答对题次 / 实际作答题次，未作答的题不计入分母。
    榜单与个人正确率都实时读这些字段，因此**所有答题入口**（公开试卷、班级作业考试、
    错题巩固）落库后都必须调用本函数，否则刷题后榜单与个人正确率都不会变。
    """
    try:
        profile = Profile.objects.get(user=user)
    except Profile.DoesNotExist:
        profile = Profile.objects.create(user=user)
    # 斩题榜：本次答对的题登记为「已斩获」（去重，同一道题重复答对只算 1 分）
    correct_question_ids = [r['question'].id for r in question_results if r['is_correct']]
    new_conquered = 0
    if correct_question_ids:
        # 先算出「本次新斩获」的题目数（去重后再计），供星币斩题奖励使用
        existing_ids = set(ConqueredQuestion.objects.filter(
            user=user, question_id__in=correct_question_ids).values_list('question_id', flat=True))
        new_conquered = len(set(correct_question_ids) - existing_ids)
        ConqueredQuestion.objects.bulk_create(
            [ConqueredQuestion(user=user, question_id=qid) for qid in correct_question_ids],
            ignore_conflicts=True,
        )
    # 作答题次只统计实际作答的题，未作答的题不计入正确率分母
    attempted_count = sum(1 for r in question_results if r.get('user_answer'))
    correct_count = sum(1 for r in question_results if r['is_correct'])
    # 用 F 表达式避免并发读-改-写竞态；不写 Profile.accuracy_rate（该字段已废弃，
    # 正确率统一由 answered_correct / answered_total 计算，见 accuracy_percent）
    Profile.objects.filter(pk=profile.pk).update(
        total_score=F('total_score') + score,
        tests_taken=F('tests_taken') + 1,
        answered_total=F('answered_total') + attempted_count,
        answered_correct=F('answered_correct') + correct_count,
        # 斩题数口径 = 去重表条数 + 斩题卡加成；必须带上加成，否则道具效果会被本次覆盖归零
        conquered_count=(ConqueredQuestion.objects.filter(user=user).count()
                         + profile.conquered_bonus),
    )
    # 星币斩题奖励（独立子系统，按本次新增斩获题数逐次发放；失败不影响主流程）
    if new_conquered:
        from starcoin import hooks as star_hooks
        star_hooks.on_questions_conquered(user, new_conquered)


def submit_paper_records(user, test_paper, questions, user_answers, is_wrong_paper=False,
                         duration_seconds=None, event='paper', hinted_question_ids=frozenset()):
    """提交答案并落库：计算得分 → 创建 TestRecord/AnswerRecord → 错题本 → Profile 统计。
    公开试卷手动提交与限时到期自动提交共用，避免两处重复逻辑。
    duration_seconds 为本次答题用时（秒），透传给 TestRecord。
    event 标识来源（'paper' 公开试卷 / 'assignment' 班级作业），用于星币活跃奖励分流。
    hinted_question_ids 为本轮答题中使用过提示卡的题目 id 集合（由调用方从 session 取出）。
    返回 (test_record, score, correct_count, wrong_count, question_results)。
    """
    score, correct_count, wrong_count, total_count, question_results = calculate_score(questions, user_answers)
    test_record, _wrong_questions_list = create_test_and_answer_records(
        user, test_paper, questions, score, question_results,
        is_wrong_paper=is_wrong_paper, duration_seconds=duration_seconds)
    # 错题本消除机制：答错入库/扣连对次数，答对累计连对次数（达 2 次消除）
    update_wrong_question_notebook(user, question_results,
                                   hinted_question_ids=hinted_question_ids)
    # 榜单统计（得分 / 斩题数 / 作答题次）
    update_profile_leaderboard_stats(user, score, question_results)
    # 星币活跃奖励（独立子系统，失败不影响主流程）
    from starcoin import hooks as star_hooks
    if event == 'assignment':
        star_hooks.on_assignment_submitted(user)
    else:
        total = getattr(test_paper, 'total_score', 0) or 0
        percent = round(score * 100.0 / total, 1) if total else None
        star_hooks.on_paper_submitted(user, score_percent=percent)
    return test_record, score, correct_count, wrong_count, question_results


# ===== P3 榜单查询公共函数 =====
# 三榜口径（首页全站个人榜 与 班级模块班级榜 共用同一套口径）：
#   斩题榜   → 答对且去重的题目数（Profile.conquered_count）
#   得分榜   → 按题目分值累加的累计得分（Profile.total_score）
#   正确率榜 → 答对题次 / 累计作答题次，需累计作答 >= MIN_ANSWERS_FOR_ACCURACY_RANK 才上榜
# 参与榜单排名的会员角色：仅「学生」上榜，教师 / 管理员角色不参与。
# 这里刻意不看 is_staff——班级管理员常由学生担任，他们需要后台权限但仍应参与排名。
RANKABLE_ROLES = ('student',)

LEADERBOARD_TOP_N = 10

BOARD_CONQUERED = 'conquered'
BOARD_SCORE = 'score'
BOARD_ACCURACY = 'accuracy'

# (key, 名称, 图标)
LEADERBOARD_BOARDS = (
    (BOARD_CONQUERED, '斩题榜', '🗡️'),
    (BOARD_SCORE, '得分榜', '🏆'),
    (BOARD_ACCURACY, '正确率榜', '🎯'),
)


def accuracy_percent(correct, total):
    """正确率（百分数，保留 1 位小数）；分母为 0 时返回 0.0"""
    return round(correct * 100.0 / total, 1) if total else 0.0


def _display_name(profile):
    """榜单展示名：优先 Profile.name，其次注册时填写的姓名（User.first_name），最后用户名。

    注册流程把「姓名」写入 User.first_name，Profile.name 多为空，
    若只看 Profile.name 会大面积回退成用户名。
    """
    return (profile.name or profile.user.first_name or profile.user.username or '').strip()


def _personal_cells(board_key, profile):
    """个人榜单元格文案：(主数值, 副信息)"""
    if board_key == BOARD_ACCURACY:
        rate = accuracy_percent(profile.answered_correct, profile.answered_total)
        return f'{rate}%', f'答对 {profile.answered_correct} / 作答 {profile.answered_total}'
    if board_key == BOARD_SCORE:
        return f'{profile.total_score} 分', f'斩题 {profile.conquered_count} 题'
    return f'{profile.conquered_count} 题', f'累计得分 {profile.total_score}'


def _build_personal_leaderboards(rankable, user=None, top_n=LEADERBOARD_TOP_N):
    """按给定 Profile 查询集生成三张个人榜（全站榜与班内榜共用同一套口径）。

    rankable 为参与排名的 Profile 查询集，调用方负责名额过滤（教师/审核状态等）。
    top_n 为 None 表示不限条数（班内榜展示全部成员）。
    user 为登录用户时追加 me（自己在各榜的名次与数值）；未上榜或未达门槛时 me 为 None。
    返回 [{'key', 'name', 'icon', 'entries', 'me'}]。
    """
    accuracy_qs = rankable.filter(
        answered_total__gte=MIN_ANSWERS_FOR_ACCURACY_RANK).annotate(
        rate=ExpressionWrapper(
            F('answered_correct') * 100.0 / F('answered_total'), output_field=FloatField()))

    querysets = {
        BOARD_CONQUERED: rankable.filter(conquered_count__gt=0).order_by(
            '-conquered_count', '-answered_total', 'user_id'),
        BOARD_SCORE: rankable.filter(total_score__gt=0).order_by(
            '-total_score', '-answered_total', 'user_id'),
        BOARD_ACCURACY: accuracy_qs.order_by('-rate', '-answered_total', 'user_id'),
    }

    # 当前用户的 Profile（rankable 已按角色过滤，教师/管理员自然取不到，无需再判断身份）
    me_profile = None
    if user is not None and user.is_authenticated:
        me_profile = rankable.filter(user=user).first()
    my_user_id = me_profile.user_id if me_profile else None

    boards = []
    for key, name, icon in LEADERBOARD_BOARDS:
        full_qs = querysets[key]
        entry_qs = full_qs if top_n is None else full_qs[:top_n]
        entries = []
        for index, profile in enumerate(entry_qs, start=1):
            value, sub = _personal_cells(key, profile)
            entries.append({'rank': index, 'name': _display_name(profile),
                            'class_name': profile.class_obj.name if profile.class_obj else '',
                            'avatar_frame': profile.avatar_frame,
                            'value': value, 'sub': sub, 'is_me': profile.user_id == my_user_id})
        # 名次取「自己在完整榜单中的位次」，与榜单行的显示顺序严格一致。
        # 不能用「胜过多人数 + 1」：并列时它忽略次级排序（作答题次），
        # 会让卡片名次与行内名次差 1 位。
        me = None
        if my_user_id is not None:
            ordered_ids = list(full_qs.values_list('user_id', flat=True))
            if my_user_id in ordered_ids:
                value, sub = _personal_cells(key, me_profile)
                me = {'rank': ordered_ids.index(my_user_id) + 1, 'value': value, 'sub': sub}
        boards.append({'key': key, 'name': name, 'icon': icon, 'entries': entries, 'me': me})
    return boards


def get_site_leaderboards(user=None, top_n=LEADERBOARD_TOP_N):
    """全站个人榜：三个榜单各取 Top N，并附带当前用户自己的排名。"""
    # 有作答记录的学生才参与排名（班级管理员若是学生角色同样参与）
    rankable = Profile.objects.filter(
        role__in=RANKABLE_ROLES, answered_total__gt=0).select_related('user', 'class_obj')
    return _build_personal_leaderboards(rankable, user, top_n)


def get_class_member_leaderboards(class_obj, user=None):
    """班内个人榜：本班审核通过的学生之间排名，展示全部成员（不截断）。

    口径与全站个人榜一致，便于学生对照自己在班级与全站的位置。
    """
    rankable = Profile.objects.filter(
        class_obj=class_obj, approval_status=1, role__in=RANKABLE_ROLES,
        answered_total__gt=0).select_related('user', 'class_obj')
    return _build_personal_leaderboards(rankable, user, top_n=None)


def get_class_leaderboards(my_class_ids=None):
    """班级榜：把班级成员的数据聚合成班级分数，班级之间排名。

    仅统计审核通过的学生（教师与未审核用户不计入）。
    班级榜排序按累计总量，同时给出人均值，避免只看班级人数。
    正确率榜沿用个人榜门槛：班级累计作答题次达标才参与排名，未达标的班级单独列出。
    my_class_ids：当前用户所属（管理员或学生身份）的全部班级ID集合，
    一个用户可能同时属于多个班级，这些班级都会被标记为 is_mine。
    返回 [{'key', 'name', 'icon', 'entries', 'unranked', 'me'}]。
    """
    # 归一化为集合：None/可迭代对象均可；is_mine 按成员归属判断（支持多班级）
    my_class_ids = set(my_class_ids or [])
    rows = (Profile.objects.filter(
                class_obj__isnull=False, approval_status=1, role__in=RANKABLE_ROLES)
            .values('class_obj_id')
            .annotate(
                members=Count('id'),
                conquered=Sum('conquered_count'),
                score=Sum('total_score'),
                answered=Sum('answered_total'),
                correct=Sum('answered_correct'),
            ))
    class_names = dict(Class.objects.filter(
        id__in=[row['class_obj_id'] for row in rows]).values_list('id', 'name'))

    items = []
    for row in rows:
        members = row['members'] or 0
        answered = row['answered'] or 0
        correct = row['correct'] or 0
        conquered = row['conquered'] or 0
        score = row['score'] or 0
        items.append({
            'class_id': row['class_obj_id'],
            'class_name': class_names.get(row['class_obj_id'], ''),
            'members': members,
            'conquered': conquered,
            'score': score,
            'answered': answered,
            'correct': correct,
            'rate': accuracy_percent(correct, answered),
            'conquered_avg': round(conquered / members, 1) if members else 0,
            'score_avg': round(score / members, 1) if members else 0,
        })

    def make_entry(rank, item, value, detail):
        return {
            'rank': rank, 'class_id': item['class_id'], 'class_name': item['class_name'],
            'value': value, 'detail': detail, 'members': item['members'],
            'is_mine': item['class_id'] in my_class_ids,
        }

    def build(key, sort_key, cells, rankable_items):
        ranked = sorted(rankable_items, key=lambda item: (sort_key(item), -item['answered'], item['class_id']))
        entries = [make_entry(i, item, *cells(item)) for i, item in enumerate(ranked, start=1)]
        unranked = []
        if key == BOARD_ACCURACY:
            rest = [item for item in items if item['answered'] < MIN_ANSWERS_FOR_ACCURACY_RANK]
            unranked = [make_entry(None, item, *cells(item)) for item in sorted(
                rest, key=lambda item: (-item['answered'], item['class_id']))]
        me = next((e for e in entries if e['is_mine']), None)
        return {'key': key, 'name': '', 'icon': '', 'entries': entries,
                'unranked': unranked, 'me': me}

    boards = []
    for key, name, icon in LEADERBOARD_BOARDS:
        if key == BOARD_CONQUERED:
            board = build(key, lambda item: -item['conquered'],
                          lambda item: (f"{item['conquered']} 题", f"人均 {item['conquered_avg']} 题"), items)
        elif key == BOARD_SCORE:
            board = build(key, lambda item: -item['score'],
                          lambda item: (f"{item['score']} 分", f"人均 {item['score_avg']} 分"), items)
        else:
            qualified = [item for item in items if item['answered'] >= MIN_ANSWERS_FOR_ACCURACY_RANK]
            board = build(key, lambda item: -item['rate'],
                          lambda item: (f"{item['rate']}%", f"答对 {item['correct']} / 作答 {item['answered']}"),
                          qualified)
        board['name'] = name
        board['icon'] = icon
        boards.append(board)
    return boards


# ===== 榜单分享图（服务端生成带网站二维码的图片）=====

def pick_board(boards, board_key):
    """从榜单列表中按 key 取榜单，缺失时回退到第一个"""
    for board in boards:
        if board['key'] == board_key:
            return board
    return boards[0]


def _share_rows(entries):
    """把榜单条目整理成分享图行数据（兼容个人榜与班级榜两种字段结构）

    副信息优先级：班级榜的 detail（人均值）→ 个人榜的 class_name（班级）→ 兜底 sub。
    """
    rows = []
    for entry in entries:
        rows.append({
            'rank': entry.get('rank'),
            'name': entry.get('name') or entry.get('class_name') or '',
            'sub': entry.get('detail') or entry.get('class_name') or entry.get('sub') or '',
            'value': entry.get('value') or '',
        })
    return rows


def leaderboard_share_view(request, board, title, subtitle, filename):
    """统一的榜单分享图响应：渲染图片 + 发放「分享榜单」奖励（每日一次）。

    注意：图片文字统一不含 emoji —— 内置中文字体不含彩色 emoji，会渲染成方框。
    """
    buffer = render_leaderboard_share_image(
        title, subtitle, _share_rows(board['entries']), share_site_url(request))
    if request.user.is_authenticated:
        from starcoin import hooks as star_hooks
        star_hooks.on_leaderboard_shared(request.user)
    return leaderboard_share_response(buffer, filename)


def site_leaderboard_share(request):
    """全站个人榜分享图：?board=conquered|score|accuracy"""
    board = pick_board(get_site_leaderboards(request.user), request.GET.get('board'))
    return leaderboard_share_view(
        request, board,
        f"全站{board['name']} · 来斩题",
        f"{timezone.localdate():%Y年%m月%d日} 全站排行榜 · 扫码一起来斩题",
        f'site_{board["key"]}.png')

