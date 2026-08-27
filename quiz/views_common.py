from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db import models
from django.db.models import Count, F, Q, Sum  # P2-1 拆分后各子模块经 common 复用
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
from .models import Question, TestPaper, Profile, TestRecord, AnswerRecord, WrongQuestion, Class, ClassAdmin, ClassApplication, ClassAssignment, ClassAssignmentRecord, Subject, Chapter, Section, KnowledgePoint, Notification, TestDraft
from .utils import paginate_queryset, compare_answers, calculate_score, parse_datetime_local, download_template_response, import_questions_from_excel, parse_options
from .captcha import generate_captcha_text, generate_captcha_image
import datetime
import json
import re
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
        chapter_obj, _ = Chapter.objects.get_or_create(
            subject=subject_obj,
            title=chapter_title,
            defaults={'number': Chapter.objects.filter(subject=subject_obj).count() + 1}
        )
    if chapter_obj and section_title:
        section_obj, _ = Section.objects.get_or_create(
            chapter=chapter_obj,
            title=section_title,
            defaults={'number': Section.objects.filter(chapter=chapter_obj).count() + 1}
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


def create_test_and_answer_records(user, test_paper, questions, score, question_results, is_wrong_paper=False):
    """创建 TestRecord + 全部 AnswerRecord（bulk_create 一次插入），
    返回 (test_record, wrong_questions)。
    wrong_questions 为本次答错的 question 列表，供调用方处理错题本。
    """
    test_record = TestRecord.objects.create(
        user=user,
        test_paper=test_paper,
        score=score,
        total_score=test_paper.total_score,
        completed_at=timezone.now(),
        is_wrong_paper=is_wrong_paper,
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
        if not result['is_correct']:
            wrong_questions.append(question)
    AnswerRecord.objects.bulk_create(answer_records)
    return test_record, wrong_questions


def submit_paper_records(user, test_paper, questions, user_answers, is_wrong_paper=False):
    """提交答案并落库：计算得分 → 创建 TestRecord/AnswerRecord → 错题本 → Profile 统计。
    公开试卷手动提交与限时到期自动提交共用，避免两处重复逻辑。
    返回 (test_record, score, correct_count, wrong_count, question_results)。
    """
    score, correct_count, wrong_count, total_count, question_results = calculate_score(questions, user_answers)
    test_record, wrong_questions_list = create_test_and_answer_records(
        user, test_paper, questions, score, question_results, is_wrong_paper=is_wrong_paper)
    # 自动添加错题到错题本（key 兼容 int/str，草稿 answers 使用 str key）
    for question in wrong_questions_list:
        ans = user_answers.get(question.id)
        if ans is None:
            ans = user_answers.get(str(question.id))
        WrongQuestion.objects.get_or_create(
            user=user,
            question=question,
            defaults={
                'user_answer': ans or '',
                'correct_answer': question.correct_answer
            }
        )
    try:
        profile = Profile.objects.get(user=user)
    except Profile.DoesNotExist:
        profile = Profile.objects.create(user=user)
    # 用 F 表达式避免并发读-改-写竞态；不写 accuracy_rate（语义错误，改由 AnswerRecord 聚合）
    Profile.objects.filter(pk=profile.pk).update(
        total_score=F('total_score') + score,
        tests_taken=F('tests_taken') + 1,
    )
    return test_record, score, correct_count, wrong_count, question_results

