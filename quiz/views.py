from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import IntegrityError
from django.contrib.auth.models import User
from django.utils import timezone
from .models import Question, TestPaper, Profile, TestRecord, AnswerRecord, WrongQuestion, Class, ClassAdmin, ClassApplication, ClassAssignment, ClassAssignmentRecord
from .utils import paginate_queryset, compare_answers, calculate_score, parse_datetime_local, download_template_response, import_questions_from_excel
from .captcha import generate_captcha_text, generate_captcha_image
import datetime
import json
import re

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

# 试卷列表视图（仅显示已发布的试卷）
def test_paper_list(request):
    test_papers = TestPaper.objects.filter(is_published=True, source='admin').order_by('-created_at')
    paginated_test_papers = paginate_queryset(test_papers, request.GET.get('page'), items_per_page=9)
    return render(request, 'quiz/frontend/test_paper_list.html', {'test_papers': paginated_test_papers})

# 试卷详情视图
def test_paper_detail(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    # 确保只显示已发布的试卷
    if not test_paper.is_published:
        return redirect('test_paper_list')
    
    # 检查用户是否登录
    if not request.user.is_authenticated:
        # 未登录用户跳转到登录页面
        return redirect('login')
    
    # 检查用户是否已审核通过
    if request.user.profile.approval_status != 1:
        # 未审核或审核拒绝的用户跳转到审核页面
        return render(request, 'quiz/frontend/approval_pending.html', {
            'status': request.user.profile.get_approval_status_display()
        })
    
    return render(request, 'quiz/frontend/test_paper_detail.html', {'test_paper': test_paper})

# 试卷提交处理视图
@login_required
def submit_test_paper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    
    # 检查用户是否已审核通过
    if request.user.profile.approval_status != 1:
        # 未审核或审核拒绝的用户跳转到审核页面
        return render(request, 'quiz/frontend/approval_pending.html', {
            'status': request.user.profile.get_approval_status_display()
        })
    
    if request.method == 'POST':
        total_score = 0
        user_answers = {}
        correct_count = 0
        question_results = []
        wrong_questions = []  # 用于收集错题
        
        # 收集用户答案并计算得分
        for question in test_paper.questions.all():
            question_num = question.id
            user_answer = request.POST.get(f'question_{question_num}')
            user_answers[question_num] = user_answer
            
            # 检查用户答案是否正确：忽略大小写并去除两端空格
            if user_answer and user_answer.strip().lower() == question.correct_answer.strip().lower():
                total_score += question.score
                correct_count += 1
                result = '正确'
            elif user_answer is None:
                result = '未答'  # 用户未回答
            else:
                result = '错误'
            
            question_results.append({
                'question': question,
                'user_answer': user_answer,
                'correct_answer': question.correct_answer,
                'result': result,
                'score': question.score
            })
        
        total_questions = test_paper.questions.count()
        wrong_count = total_questions - correct_count
        
        # 创建测试记录
        test_record = TestRecord.objects.create(
            user=request.user,
            test_paper=test_paper,
            score=total_score,
            total_score=test_paper.total_score
        )
        
        # 创建每题答题记录并收集错题
        for question in test_paper.questions.all():
            question_num = question.id
            user_answer = user_answers.get(question_num)
            
            # 检查用户答案是否正确
            if user_answer and user_answer.strip().lower() == question.correct_answer.strip().lower():
                is_correct = True
            else:
                is_correct = False
                # 收集错题
                if user_answer is not None:  # 用户已回答但错误
                    wrong_questions.append(question)
            
            # 创建答题记录
            AnswerRecord.objects.create(
                test_record=test_record,
                question=question,
                user_answer=user_answer,
                correct_answer=question.correct_answer,
                is_correct=is_correct,
                original_question_content=question.content,
                original_question_type=question.type,
                original_options=question.options,
                original_explanation=question.explanation
            )
        
        # 将错题添加到错题本
        for question in wrong_questions:
            # 查找该题对应的用户答案
            user_answer = user_answers.get(question.id)
            try:
                WrongQuestion.objects.create(user=request.user, question=question, user_answer=user_answer)
            except IntegrityError:
                # 如果错题已经存在于错题本中，更新用户答案
                wrong_question = WrongQuestion.objects.get(user=request.user, question=question)
                wrong_question.user_answer = user_answer
                wrong_question.save()
        
        return render(request, 'quiz/frontend/test_paper_result.html', {
            'test_paper': test_paper,
            'total_score': total_score,
            'user_answers': user_answers,
            'correct_count': correct_count,
            'wrong_count': wrong_count,
            'total_questions': total_questions,
            'question_results': question_results
        })
    return redirect('test_paper_detail', paper_id=paper_id)

# 注册视图
def register(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        password_confirm = request.POST.get('password_confirm')
        email = request.POST.get('email')
        phone_number = request.POST.get('phone_number')
        qq_number = request.POST.get('qq_number')
        
        # 检查必填字段
        if not username or not password or not password_confirm or not email:
            messages.error(request, '请填写完整的注册信息')
            return render(request, 'quiz/frontend/register.html')
        
        # 验证密码一致性
        if password != password_confirm:
            messages.error(request, '两次输入的密码不一致')
            return render(request, 'quiz/frontend/register.html')
        
        # 检查用户名唯一性
        if User.objects.filter(username=username).exists():
            messages.error(request, '用户名已存在')
            return render(request, 'quiz/frontend/register.html')
        
        # 检查邮箱唯一性
        if User.objects.filter(email=email).exists():
            messages.error(request, '邮箱已存在')
            return render(request, 'quiz/frontend/register.html')
        
        # 验证手机号码格式和唯一性
        if phone_number:
            phone_regex = re.compile(r'^1[3-9]\d{9}$')
            if not phone_regex.match(phone_number):
                messages.error(request, '手机号码格式不正确')
                return render(request, 'quiz/frontend/register.html')
            
            # 检查手机号码唯一性
            if Profile.objects.filter(phone_number=phone_number).exists():
                messages.error(request, '手机号码已存在')
                return render(request, 'quiz/frontend/register.html')
        
        try:
            # 创建用户
            user = User.objects.create_user(
                username=username,
                password=password,
                email=email
            )
            
            # 保存手机号码和QQ号码到Profile
            if phone_number:
                user.profile.phone_number = phone_number
            if qq_number:
                user.profile.qq_number = qq_number
            user.profile.save()
            
            messages.success(request, '注册成功，请等待管理员审核')
            return redirect('login')
        except IntegrityError:
            messages.error(request, '用户名或者手机号码已存在')
            return render(request, 'quiz/frontend/register.html')
    
    return render(request, 'quiz/frontend/register.html')

# 验证码视图
def captcha_image(request):
    """生成验证码图片"""
    captcha_text = generate_captcha_text()
    request.session['captcha'] = captcha_text.lower()  # 保存到session，不区分大小写
    image_buffer = generate_captcha_image(captcha_text)
    return HttpResponse(image_buffer, content_type='image/png')


# 刷新验证码
def refresh_captcha(request):
    """刷新验证码"""
    captcha_text = generate_captcha_text()
    request.session['captcha'] = captcha_text.lower()
    image_buffer = generate_captcha_image(captcha_text)
    return HttpResponse(image_buffer, content_type='image/png')


# 登录视图
def login_view(request):
    if request.method == 'POST':
        username_or_phone = request.POST.get('username')
        password = request.POST.get('password')
        captcha = request.POST.get('captcha', '').lower()
        
        # 验证验证码
        session_captcha = request.session.get('captcha', '')
        if captcha != session_captcha:
            messages.error(request, '验证码错误')
            return render(request, 'quiz/frontend/login.html')
        
        # 首先尝试通过用户名登录
        user = authenticate(request, username=username_or_phone, password=password)
        
        # 如果用户名登录失败，尝试通过手机号码登录
        if user is None:
            try:
                # 通过手机号码查找对应的Profile
                profile = Profile.objects.get(phone_number=username_or_phone)
                # 获取对应的用户对象
                user = profile.user
                # 验证密码
                if user.check_password(password):
                    # 密码正确，登录用户
                    login(request, user)
                    messages.success(request, '登录成功')
                    return redirect('test_paper_list')
            except Profile.DoesNotExist:
                # 手机号码不存在
                pass
            except:
                # 其他错误
                pass
        
        # 如果两种方式都登录失败
        if user is None:
            messages.error(request, '用户名/手机号码或密码错误')
            return render(request, 'quiz/frontend/login.html')
        else:
            login(request, user)
            messages.success(request, '登录成功')
            return redirect('test_paper_list')
    
    return render(request, 'quiz/frontend/login.html')

# 退出登录视图
def logout_view(request):
    logout(request)
    messages.success(request, '已退出登录')
    return redirect('test_paper_list')

# 用户中心视图
@login_required
def user_center(request):
    # 获取当前用户的所有答题记录
    test_records = TestRecord.objects.filter(user=request.user)
    
    # 统计数据
    test_count = test_records.count()  # 答题记录数（包含错题组卷）
    completed_count = test_records.filter(test_paper__isnull=False).count()  # 完成试卷数（排除错题组卷）
    wrong_count = WrongQuestion.objects.filter(user=request.user).count()  # 错题数量
    
    # 使用聚合查询计算正确率
    answer_records = AnswerRecord.objects.filter(test_record__user=request.user)
    total_answers = answer_records.count()
    correct_answers = answer_records.filter(is_correct=True).count()
    
    accuracy_rate = 0
    if total_answers > 0:
        accuracy_rate = int(round(correct_answers / total_answers * 100))
    
    return render(request, 'quiz/frontend/user_center.html', {
        'test_count': test_count,
        'completed_count': completed_count,
        'wrong_count': wrong_count,
        'accuracy_rate': accuracy_rate
    })

# 答题历史记录视图
@login_required
def test_history(request):
    test_records = TestRecord.objects.filter(user=request.user).order_by('-completed_at')
    paginated_records = paginate_queryset(test_records, request.GET.get('page'), items_per_page=9)
    return render(request, 'quiz/frontend/test_history.html', {
        'test_records': paginated_records
    })

@login_required
def test_history_detail(request, record_id):
    # 获取答题记录
    test_record = get_object_or_404(TestRecord, pk=record_id)
    
    # 确保当前用户只能查看自己的答题记录
    if test_record.user != request.user:
        messages.error(request, '您没有权限查看此答题记录')
        return redirect('test_history')
    
    # 获取该答题记录的所有每题答题记录
    answer_records = AnswerRecord.objects.filter(test_record=test_record).select_related('question')
    
    return render(request, 'quiz/frontend/test_history_detail.html', {
        'test_record': test_record,
        'answer_records': answer_records
    })

# 错题本视图
@login_required
def wrong_question_notebook(request):
    wrong_questions = WrongQuestion.objects.filter(user=request.user).order_by('-added_at')
    paginated_wrong_questions = paginate_queryset(wrong_questions, request.GET.get('page'), items_per_page=50)
    return render(request, 'quiz/frontend/wrong_question_notebook.html', {
        'wrong_questions': paginated_wrong_questions
    })

# 错题本组卷视图
@login_required
def create_wrong_question_paper(request):
    if request.method == 'POST':
        # 获取选中的题目ID列表
        selected_question_ids = request.POST.getlist('selected_questions')
        
        if not selected_question_ids:
            messages.error(request, '请至少选择一道错题')
            return redirect('wrong_question_notebook')
        
        # 获取当前用户选中的错题，按添加时间倒序排序
        wrong_questions = WrongQuestion.objects.filter(
            user=request.user,
            question_id__in=selected_question_ids
        ).order_by('-added_at')
    else:
        # 默认情况下显示所有错题
        wrong_questions = WrongQuestion.objects.filter(user=request.user).order_by('-added_at')
    
    if wrong_questions.count() == 0:
        messages.info(request, '您的错题本中没有题目')
        return redirect('wrong_question_notebook')
    
    # 计算总分
    total_score = sum(wq.question.score for wq in wrong_questions)
    
    return render(request, 'quiz/frontend/wrong_question_paper.html', {
        'wrong_questions': wrong_questions,
        'total_score': total_score
    })

# 删除错题视图
@login_required
def delete_wrong_question(request, wrong_question_id):
    wrong_question = get_object_or_404(WrongQuestion, pk=wrong_question_id)
    # 检查是否是当前用户的错题
    if wrong_question.user == request.user:
        wrong_question.delete()
        messages.success(request, '错题已删除')
    else:
        messages.error(request, '您没有权限删除这道错题')
    return redirect('wrong_question_notebook')

# 错题本试卷提交视图
@login_required
def submit_wrong_question_paper(request):
    if request.method == 'POST':
        user_score = 0  # 用户实际得分
        total_possible_score = 0  # 总分（所有题目分数之和）
        correct_count = 0
        question_results = []
        user_answers = {}
        
        # 获取所有题目ID
        question_ids = request.POST.getlist('question_id')
        
        for question_id in question_ids:
            question = get_object_or_404(Question, pk=question_id)
            total_possible_score += question.score  # 累加总分
            
            user_answer = request.POST.get(f'question_{question_id}')
            user_answers[question_id] = user_answer
            
            # 检查用户答案是否正确
            if user_answer and user_answer.strip().lower() == question.correct_answer.strip().lower():
                is_correct = True
                user_score += question.score  # 累加用户得分
                correct_count += 1
                result = '正确'
            elif user_answer is None:
                is_correct = False
                result = '未答'
            else:
                is_correct = False
                result = '错误'
            
            question_results.append({
                'question': question,
                'user_answer': user_answer,
                'correct_answer': question.correct_answer,
                'result': result,
                'score': question.score,
                'is_correct': is_correct
            })
        
        total_questions = len(question_ids)
        wrong_count = total_questions - correct_count
        
        # 创建测试记录（模拟试卷名称为"错题复习"）
        test_record = TestRecord.objects.create(
            user=request.user,
            test_paper=None,
            score=user_score,
            total_score=total_possible_score,
            is_wrong_paper=True
        )
        
        # 创建每题答题记录并处理错题
        for question_id in question_ids:
            question = get_object_or_404(Question, pk=question_id)
            user_answer = user_answers.get(question_id)
            
            # 检查用户答案是否正确
            if user_answer and user_answer.strip().lower() == question.correct_answer.strip().lower():
                is_correct = True
                # 答对的题目从错题本中移除
                WrongQuestion.objects.filter(user=request.user, question=question).delete()
            else:
                is_correct = False
                # 更新错题记录的用户答案
                try:
                    wrong_question = WrongQuestion.objects.get(user=request.user, question=question)
                    wrong_question.user_answer = user_answer
                    wrong_question.save()
                except WrongQuestion.DoesNotExist:
                    pass
            
            # 创建答题记录
            AnswerRecord.objects.create(
                test_record=test_record,
                question=question,
                user_answer=user_answer,
                correct_answer=question.correct_answer,
                is_correct=is_correct,
                original_question_content=question.content,
                original_question_type=question.type,
                original_options=question.options,
                original_explanation=question.explanation
            )
        
        return render(request, 'quiz/frontend/wrong_question_paper_result.html', {
            'total_score': total_possible_score,
            'obtained_score': user_score,
            'correct_count': correct_count,
            'wrong_count': wrong_count,
            'total_questions': total_questions,
            'question_results': question_results
        })
    
    return redirect('create_wrong_question_paper')


# ==================== 班级管理视图 ====================

def is_class_admin(user, class_obj):
    """检查用户是否是班级管理员"""
    return ClassAdmin.objects.filter(user=user, class_obj=class_obj).exists()

@login_required
def class_list(request):
    """班级列表视图"""
    classes = Class.objects.all().order_by('name')
    return render(request, 'quiz/frontend/class_list.html', {'classes': classes})

@login_required
def class_detail(request, class_id):
    """班级详情视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    students = User.objects.filter(profile__class_obj=class_obj).order_by('username')
    admins = ClassAdmin.objects.filter(class_obj=class_obj).select_related('user')
    is_admin = is_class_admin(request.user, class_obj)
    pending_count = ClassApplication.objects.filter(class_obj=class_obj, status=0).count()
    
    return render(request, 'quiz/frontend/class_detail.html', {
        'class_obj': class_obj,
        'students': students,
        'admins': admins,
        'is_admin': is_admin,
        'pending_count': pending_count
    })

@login_required
def create_class(request):
    """创建班级视图"""
    if not request.user.is_superuser:
        messages.error(request, '您没有权限创建班级')
        return redirect('class_list')
    
    if request.method == 'POST':
        code = request.POST.get('code')
        name = request.POST.get('name')
        description = request.POST.get('description')
        
        if not code or not name:
            messages.error(request, '班级编号和名称不能为空')
            return render(request, 'quiz/frontend/create_class.html')
        
        if Class.objects.filter(code=code).exists():
            messages.error(request, '班级编号已存在')
            return render(request, 'quiz/frontend/create_class.html')
        
        Class.objects.create(code=code, name=name, description=description)
        messages.success(request, '班级创建成功')
        return redirect('class_list')
    
    return render(request, 'quiz/frontend/create_class.html')

@login_required
def edit_class(request, class_id):
    """编辑班级视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    
    # 只有超级管理员可以编辑班级
    if not request.user.is_superuser:
        messages.error(request, '您没有权限编辑班级')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        name = request.POST.get('name')
        description = request.POST.get('description')
        
        if not name:
            messages.error(request, '班级名称不能为空')
            return render(request, 'quiz/frontend/edit_class.html', {'class_obj': class_obj})
        
        class_obj.name = name
        class_obj.description = description
        class_obj.save()
        messages.success(request, '班级信息更新成功')
        return redirect('class_detail', class_id=class_id)
    
    return render(request, 'quiz/frontend/edit_class.html', {'class_obj': class_obj})

@login_required
def delete_class(request, class_id):
    """删除班级视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    
    # 只有超级管理员可以删除班级
    if not request.user.is_superuser:
        messages.error(request, '您没有权限删除班级')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        class_obj.delete()
        messages.success(request, '班级删除成功')
        return redirect('class_list')
    
    return render(request, 'quiz/frontend/delete_class.html', {'class_obj': class_obj})

@login_required
def add_class_admin(request, class_id):
    """添加班级管理员视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    
    # 只有超级管理员可以添加班级管理员
    if not request.user.is_superuser:
        messages.error(request, '您没有权限添加班级管理员')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        username = request.POST.get('username')
        
        try:
            user = User.objects.get(username=username)
            ClassAdmin.objects.create(class_obj=class_obj, user=user)
            messages.success(request, f'已将 {username} 设置为班级管理员')
        except User.DoesNotExist:
            messages.error(request, '用户不存在')
        except IntegrityError:
            messages.error(request, '该用户已是班级管理员')
        
        return redirect('class_detail', class_id=class_id)
    
    return render(request, 'quiz/frontend/add_class_admin.html', {'class_obj': class_obj})

@login_required
def remove_class_admin(request, class_id, admin_id):
    """移除班级管理员视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    class_admin = get_object_or_404(ClassAdmin, pk=admin_id)
    
    # 只有超级管理员可以移除班级管理员
    if not request.user.is_superuser:
        messages.error(request, '您没有权限移除班级管理员')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        class_admin.delete()
        messages.success(request, '班级管理员已移除')
        return redirect('class_detail', class_id=class_id)
    
    return render(request, 'quiz/frontend/remove_class_admin.html', {
        'class_obj': class_obj,
        'class_admin': class_admin
    })

@login_required
def assign_student_to_class(request, class_id):
    """分配学生到班级视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    
    # 只有超级管理员或班级管理员可以分配学生
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限分配学生')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        username_or_phone = request.POST.get('username_or_phone')
        
        try:
            # 尝试通过用户名查找
            user = User.objects.get(username=username_or_phone)
        except User.DoesNotExist:
            try:
                # 尝试通过手机号查找
                profile = Profile.objects.get(phone_number=username_or_phone)
                user = profile.user
            except Profile.DoesNotExist:
                messages.error(request, '用户不存在')
                return redirect('class_detail', class_id=class_id)
        
        user.profile.class_obj = class_obj
        user.profile.save()
        messages.success(request, f'已将 {user.username} 分配到 {class_obj.name}')
        return redirect('class_detail', class_id=class_id)
    
    return render(request, 'quiz/frontend/assign_student.html', {'class_obj': class_obj})

@login_required
def remove_student_from_class(request, class_id, user_id):
    """从班级移除学生视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    student = get_object_or_404(User, pk=user_id)
    
    # 只有超级管理员或班级管理员可以移除学生
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限移除学生')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        student.profile.class_obj = None
        student.profile.save()
        messages.success(request, f'已将 {student.username} 从 {class_obj.name} 移除')
        return redirect('class_detail', class_id=class_id)
    
    return render(request, 'quiz/frontend/remove_student.html', {
        'class_obj': class_obj,
        'student': student
    })


# ==================== 班级申请管理视图 ====================

@login_required
def apply_to_class(request):
    """申请加入班级视图"""
    if request.method == 'POST':
        class_code = request.POST.get('class_code')
        message = request.POST.get('message', '')
        
        try:
            class_obj = Class.objects.get(code=class_code)
        except Class.DoesNotExist:
            messages.error(request, '班级编号不存在，请检查后重新输入')
            return render(request, 'quiz/frontend/apply_to_class.html')
        
        # 检查是否已是班级成员
        if request.user.profile.class_obj == class_obj:
            messages.error(request, '您已经是该班级的成员')
            return redirect('class_detail', class_id=class_obj.id)
        
        # 检查是否有待审核的申请
        existing_application = ClassApplication.objects.filter(
            class_obj=class_obj, 
            user=request.user, 
            status=0
        ).first()
        
        if existing_application:
            messages.error(request, '您已有待审核的申请，请等待审核')
            return redirect('class_detail', class_id=class_obj.id)
        
        # 检查是否曾经申请过并被拒绝，重新申请
        old_application = ClassApplication.objects.filter(
            class_obj=class_obj, 
            user=request.user
        ).first()
        
        if old_application:
            if old_application.status == 2:  # 被拒绝
                old_application.status = 0
                old_application.message = message
                old_application.save()
                messages.success(request, '重新申请已提交，请等待审核')
            else:
                messages.error(request, '您已有申请记录')
        else:
            ClassApplication.objects.create(
                class_obj=class_obj,
                user=request.user,
                message=message
            )
            messages.success(request, '申请已提交，请等待班级管理员审核')
        
        return redirect('class_detail', class_id=class_obj.id)
    
    return render(request, 'quiz/frontend/apply_to_class.html')


@login_required
def my_applications(request):
    """我的申请记录视图"""
    applications = ClassApplication.objects.filter(user=request.user).select_related('class_obj').order_by('-created_at')
    return render(request, 'quiz/frontend/my_applications.html', {'applications': applications})


@login_required
def class_applications(request, class_id):
    """班级申请列表视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    
    # 只有超级管理员或班级管理员可以查看申请列表
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限查看申请列表')
        return redirect('class_detail', class_id=class_id)
    
    pending_applications = ClassApplication.objects.filter(class_obj=class_obj, status=0).select_related('user').order_by('-created_at')
    processed_applications = ClassApplication.objects.filter(class_obj=class_obj, status__in=[1, 2]).select_related('user', 'reviewed_by').order_by('-created_at')[:20]
    
    return render(request, 'quiz/frontend/class_applications.html', {
        'class_obj': class_obj,
        'pending_applications': pending_applications,
        'processed_applications': processed_applications
    })


@login_required
def approve_application(request, class_id, application_id):
    """审核通过申请视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    application = get_object_or_404(ClassApplication, pk=application_id)
    
    # 只有超级管理员或班级管理员可以审核
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限审核申请')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        application.status = 1
        application.reviewed_at = timezone.now()
        application.reviewed_by = request.user
        application.save()
        
        # 自动将学生分配到班级
        application.user.profile.class_obj = class_obj
        application.user.profile.save()
        
        messages.success(request, f'已通过 {application.user.username} 的加入申请')
        return redirect('class_applications', class_id=class_id)
    
    return render(request, 'quiz/frontend/approve_application.html', {
        'class_obj': class_obj,
        'application': application
    })


@login_required
def reject_application(request, class_id, application_id):
    """审核拒绝申请视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    application = get_object_or_404(ClassApplication, pk=application_id)
    
    # 只有超级管理员或班级管理员可以审核
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限审核申请')
        return redirect('class_detail', class_id=class_id)
    
    if request.method == 'POST':
        application.status = 2
        application.reviewed_at = timezone.now()
        application.reviewed_by = request.user
        application.save()
        
        messages.success(request, f'已拒绝 {application.user.username} 的加入申请')
        return redirect('class_applications', class_id=class_id)
    
    return render(request, 'quiz/frontend/reject_application.html', {
        'class_obj': class_obj,
        'application': application
    })


# ==================== 班级作业/考试功能 ====================

@login_required
def create_class_assignment(request, class_id):
    """创建班级作业/考试视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    
    # 只有超级管理员或班级管理员可以创建作业
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限创建班级作业')
        return redirect('class_detail', class_id=class_id)
    
    # 获取筛选参数
    filter_type = request.GET.get('filter', 'all')
    
    # 根据筛选类型获取试卷
    if filter_type == 'my':
        available_papers = TestPaper.objects.filter(created_by=request.user.username, is_published=True)
    elif filter_type == 'published':
        available_papers = TestPaper.objects.filter(is_published=True)
    else:  # all
        # 所有已发布的试卷，优先显示自己的
        my_papers = TestPaper.objects.filter(created_by=request.user.username, is_published=True)
        other_papers = TestPaper.objects.filter(is_published=True).exclude(created_by=request.user.username)
        available_papers = list(my_papers) + list(other_papers)
    
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        paper_id = request.POST.get('paper_id')
        deadline = request.POST.get('deadline')
        assignment_type = request.POST.get('type', 1)
        
        if not title or not paper_id or not deadline:
            messages.error(request, '请填写完整信息')
            return redirect(f"{request.path}?filter={filter_type}")
        
        try:
            test_paper = TestPaper.objects.get(pk=paper_id)
            # 处理 datetime-local 格式（可能包含 'T'）
            deadline_clean = deadline.replace('T', ' ')
            deadline_datetime = datetime.datetime.strptime(deadline_clean, '%Y-%m-%d %H:%M')
            
            ClassAssignment.objects.create(
                class_obj=class_obj,
                test_paper=test_paper,
                title=title,
                description=description,
                type=int(assignment_type),
                deadline=deadline_datetime,
                created_by=request.user
            )
            
            messages.success(request, '班级作业创建成功')
            return redirect('class_assignments', class_id=class_id)
        except TestPaper.DoesNotExist:
            messages.error(request, '试卷不存在')
        except ValueError:
            messages.error(request, '时间格式错误')
    
    return render(request, 'quiz/frontend/create_class_assignment.html', {
        'class_obj': class_obj,
        'available_papers': available_papers,
        'filter_type': filter_type
    })


@login_required
def class_assignments(request, class_id):
    """班级作业列表视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    
    # 只有超级管理员或班级管理员可以查看作业列表
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限查看班级作业')
        return redirect('class_detail', class_id=class_id)
    
    assignments = ClassAssignment.objects.filter(class_obj=class_obj).order_by('-created_at')
    
    return render(request, 'quiz/frontend/class_assignments.html', {
        'class_obj': class_obj,
        'assignments': assignments
    })


@login_required
def class_assignment_detail(request, class_id, assignment_id):
    """班级作业详情视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id)
    
    # 只有超级管理员或班级管理员可以查看作业详情
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限查看作业详情')
        return redirect('class_detail', class_id=class_id)
    
    # 获取作业记录
    records = ClassAssignmentRecord.objects.filter(assignment=assignment).select_related('user').order_by('user__username')
    
    # 计算统计数据
    total_students = class_obj.get_students().count()
    completed_count = records.filter(is_submitted=True).count()
    not_submitted_count = total_students - completed_count
    
    return render(request, 'quiz/frontend/class_assignment_detail.html', {
        'class_obj': class_obj,
        'assignment': assignment,
        'records': records,
        'total_students': total_students,
        'completed_count': completed_count,
        'not_submitted_count': not_submitted_count
    })


@login_required
def publish_class_assignment(request, class_id, assignment_id):
    """发布班级作业视图"""
    class_obj = get_object_or_404(Class, pk=class_id)
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id)
    
    # 只有超级管理员或班级管理员可以发布作业
    if not (request.user.is_superuser or is_class_admin(request.user, class_obj)):
        messages.error(request, '您没有权限发布班级作业')
        return redirect('class_assignments', class_id=class_id)
    
    if request.method == 'POST':
        assignment.status = 1
        assignment.published_at = timezone.now()
        assignment.save()
        
        # 为班级所有学生创建作业记录
        students = class_obj.get_students()
        for student in students:
            ClassAssignmentRecord.objects.get_or_create(
                assignment=assignment,
                user=student
            )
        
        messages.success(request, '班级作业已发布')
        return redirect('class_assignments', class_id=class_id)
    
    return render(request, 'quiz/frontend/publish_class_assignment.html', {
        'class_obj': class_obj,
        'assignment': assignment
    })


@login_required
def student_class_assignments(request):
    """学生查看自己的班级作业视图"""
    # 获取用户所在班级的已发布作业
    assignment_list = []
    if request.user.profile.class_obj:
        assignments = ClassAssignment.objects.filter(
            class_obj=request.user.profile.class_obj,
            status=1
        ).order_by('-published_at')
        
        # 获取学生的作业记录，合并到作业列表中
        for assignment in assignments:
            record = ClassAssignmentRecord.objects.filter(
                assignment=assignment,
                user=request.user
            ).first()
            
            # 判断状态
            now = timezone.now()
            is_overdue = assignment.deadline < now and not (record and record.is_submitted)
            is_submitted = record and record.is_submitted
            
            assignment_list.append({
                'assignment': assignment,
                'record': record,
                'is_overdue': is_overdue,
                'is_submitted': is_submitted
            })
    
    return render(request, 'quiz/frontend/student_class_assignments.html', {
        'assignment_list': assignment_list
    })


@login_required
def do_class_assignment(request, assignment_id):
    """学生完成班级作业视图"""
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id)
    
    # 检查学生是否有权限完成此作业
    if request.user.profile.class_obj != assignment.class_obj:
        messages.error(request, '您没有权限完成此作业')
        return redirect('student_class_assignments')
    
    # 检查作业是否已发布
    if assignment.status != 1:
        messages.error(request, '作业尚未发布')
        return redirect('student_class_assignments')
    
    # 检查是否已提交
    record = ClassAssignmentRecord.objects.filter(
        assignment=assignment,
        user=request.user
    ).first()
    
    if record and record.is_submitted:
        messages.error(request, '您已经提交了此作业')
        return redirect('student_class_assignments')
    
    return render(request, 'quiz/frontend/do_class_assignment.html', {
        'assignment': assignment,
        'test_paper': assignment.test_paper
    })


@login_required
def submit_class_assignment(request, assignment_id):
    """提交班级作业视图"""
    assignment = get_object_or_404(ClassAssignment, pk=assignment_id)
    
    # 检查学生是否有权限提交此作业
    if request.user.profile.class_obj != assignment.class_obj:
        messages.error(request, '您没有权限提交此作业')
        return redirect('student_class_assignments')
    
    # 检查作业是否已发布
    if assignment.status != 1:
        messages.error(request, '作业尚未发布')
        return redirect('student_class_assignments')
    
    # 检查是否已提交
    record = ClassAssignmentRecord.objects.filter(
        assignment=assignment,
        user=request.user
    ).first()
    
    if record and record.is_submitted:
        messages.error(request, '您已经提交了此作业')
        return redirect('student_class_assignments')
    
    if request.method == 'POST':
        # 创建答题记录
        test_record = TestRecord.objects.create(
            user=request.user,
            test_paper=assignment.test_paper,
            score=0,
            total_score=assignment.test_paper.total_score
        )
        
        score = 0
        for question in assignment.test_paper.questions.all():
            user_answer = request.POST.get(f'question_{question.id}')
            is_correct = compare_answers(user_answer, question.correct_answer)
            
            if is_correct:
                score += question.score
            
            AnswerRecord.objects.create(
                test_record=test_record,
                question=question,
                user_answer=user_answer,
                correct_answer=question.correct_answer,
                is_correct=is_correct,
                original_question_content=question.content,
                original_question_type=question.type,
                original_options=question.options,
                original_explanation=question.explanation
            )
            
            # 添加到错题本
            if not is_correct:
                WrongQuestion.objects.get_or_create(
                    user=request.user,
                    question=question,
                    defaults={'user_answer': user_answer}
                )
        
        # 更新答题记录分数
        test_record.score = score
        test_record.save()
        
        # 更新作业记录
        if record:
            record.test_record = test_record
            record.is_submitted = True
            record.score = score
            record.submitted_at = timezone.now()
            record.save()
        else:
            ClassAssignmentRecord.objects.create(
                assignment=assignment,
                user=request.user,
                test_record=test_record,
                is_submitted=True,
                score=score,
                submitted_at=timezone.now()
            )
        
        messages.success(request, f'作业提交成功！得分：{score}/{assignment.test_paper.total_score}')
        return redirect('student_class_assignments')
    
    return redirect('do_class_assignment', assignment_id=assignment_id)


@login_required
def my_test_papers(request):
    """我的试卷视图 - 显示用户创建的所有试卷"""
    test_papers = TestPaper.objects.filter(created_by=request.user.username).order_by('-created_at')
    paginated_test_papers = paginate_queryset(test_papers, request.GET.get('page'), items_per_page=9)
    return render(request, 'quiz/frontend/my_test_papers.html', {
        'test_papers': paginated_test_papers
    })


@login_required
def create_test_paper(request):
    """创建试卷视图 - 支持手动添加题目"""
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        question_ids = request.POST.getlist('questions')  # 直接获取复选框值列表

        if title and question_ids:
            # 创建试卷
            test_paper = TestPaper.objects.create(
                title=title,
                description=description,
                created_by=request.user.username,
                is_published=False
            )

            total_score = 0
            for q_id in question_ids:
                try:
                    question = Question.objects.get(id=q_id)
                    test_paper.questions.add(question)
                    total_score += question.score
                except Question.DoesNotExist:
                    pass

            # 保存总分（信号会自动计算，但这里直接设置更明确）
            test_paper.total_score = total_score
            test_paper.save()

            messages.success(request, f'试卷 "{title}" 创建成功！共 {len(question_ids)} 道题目，总分 {total_score} 分。')
            return redirect('my_test_papers')
        else:
            messages.error(request, '请填写试卷标题并至少选择一道题目')

    # 获取所有题目供选择
    questions = Question.objects.all().order_by('id')

    # 处理options字段，确保是字典格式
    questions_list = []
    for q in questions:
        options_data = q.options
        if isinstance(options_data, str):
            import json
            try:
                options_data = json.loads(options_data)
            except:
                options_data = {}
        elif not isinstance(options_data, dict):
            options_data = {}
        
        questions_list.append({
            'id': q.id,
            'type': q.type,
            'content': q.content,
            'options': options_data,
            'score': q.score,
            'explanation': q.explanation
        })
    
    return render(request, 'quiz/frontend/create_test_paper.html', {
        'questions': questions_list
    })


@login_required
def import_test_paper(request):
    """导入试卷视图 - 支持从Excel文件导入试卷（两步流程：上传预览 → 确认导入）"""
    
    # 处理从预览页面返回并保存编辑数据
    if request.method == 'POST' and request.POST.get('action') == 'save_and_back':
        title = request.POST.get('title', '')
        description = request.POST.get('description', '')
        questions_json = request.POST.get('questions_json', '')
        
        # 保存到session
        request.session['import_paper_data'] = {
            'title': title,
            'description': description,
            'questions_json': questions_json
        }
        request.session.set_expiry(3600)  # 1小时过期
        
        return render(request, 'quiz/frontend/import_test_paper.html', {
            'saved_title': title,
            'saved_description': description,
            'saved_questions_json': questions_json,
            'show_preview_data': True
        })
    
    # 处理从预览页面返回（保留编辑数据）
    if request.method == 'GET' and request.GET.get('action') == 'back_from_preview':
        # 从session获取保存的编辑数据
        saved_data = request.session.get('import_paper_data', {})
        return render(request, 'quiz/frontend/import_test_paper.html', {
            'saved_title': saved_data.get('title', ''),
            'saved_description': saved_data.get('description', ''),
            'saved_questions_json': saved_data.get('questions_json', ''),
            'show_preview_data': True
        })
    
    # 处理恢复预览数据
    if request.method == 'POST' and request.POST.get('action') == 'restore_preview':
        title = request.POST.get('title', '')
        description = request.POST.get('description', '')
        questions_json = request.POST.get('questions_json', '')
        
        if questions_json:
            import json
            try:
                questions_data = json.loads(questions_json)
                valid_count = sum(1 for q in questions_data if q.get('correct_answer') and q.get('score'))
                missing_count = len(questions_data) - valid_count
                
                return render(request, 'quiz/frontend/import_preview.html', {
                    'title': title,
                    'description': description,
                    'questions_data': questions_data,
                    'questions_json': questions_json,
                    'total_score': sum(q.get('score', 0) for q in questions_data),
                    'valid_count': valid_count,
                    'missing_count': missing_count,
                    'errors': []
                })
            except:
                messages.error(request, '预览数据解析失败，请重新上传')
    
    # 处理确认导入
    if request.method == 'POST' and request.POST.get('action') == 'confirm_import':
        title = request.POST.get('title')
        description = request.POST.get('description')
        questions_json = request.POST.get('questions_data')
        
        if title and questions_json:
            import json
            try:
                questions_data = json.loads(questions_json)
                
                if not questions_data:
                    messages.error(request, '没有有效的题目数据')
                    return render(request, 'quiz/frontend/import_test_paper.html')
                
                # 创建试卷
                test_paper = TestPaper.objects.create(
                    title=title,
                    description=description,
                    created_by=request.user.username,
                    is_published=False
                )
                
                # 创建题目并添加到试卷
                total_score = 0
                valid_questions = 0
                for q_data in questions_data:
                    # 跳过无效题目（缺少关键信息）
                    if not q_data.get('content') or not q_data.get('correct_answer'):
                        continue
                    
                    # 处理选项：支持字典和字符串格式
                    options_data = q_data.get('options', {})
                    if isinstance(options_data, str):
                        # 如果是字符串格式，转换为字典
                        try:
                            options_data = json.loads(options_data)
                        except:
                            options_data = {}
                    
                    # 获取题目类型，默认为选择题
                    q_type = int(q_data.get('type', 1))
                    if q_type not in [1, 2, 3]:
                        q_type = 1
                    
                    # 获取分值，默认为1分
                    q_score = q_data.get('score', 1)
                    try:
                        q_score = int(q_score) if q_score else 1
                    except:
                        q_score = 1
                    
                    question = Question.objects.create(
                        type=q_type,
                        content=q_data['content'],
                        options=options_data,
                        correct_answer=q_data['correct_answer'],
                        score=q_score,
                        explanation=q_data.get('explanation', '')
                    )
                    test_paper.questions.add(question)
                    total_score += q_score
                    valid_questions += 1
                
                test_paper.total_score = total_score
                test_paper.save()
                
                messages.success(request, f'试卷 "{title}" 导入成功！共导入 {len(questions_data)} 道题目')
                return redirect('my_test_papers')
            except Exception as e:
                messages.error(request, f'导入失败：{str(e)}')
        else:
            messages.error(request, '请填写试卷标题并确认导入')
        return render(request, 'quiz/frontend/import_test_paper.html')
    
    # 处理文件上传和预览
    if request.method == 'POST' and request.FILES.get('paper_file'):
        title = request.POST.get('title', '')
        description = request.POST.get('description', '')
        file = request.FILES.get('paper_file')
        
        if not title:
            messages.error(request, '请填写试卷标题')
            return render(request, 'quiz/frontend/import_test_paper.html')
        
        try:
            import openpyxl
            from openpyxl.utils.exceptions import InvalidFileException
            
            # 读取 Excel 文件
            wb = openpyxl.load_workbook(file)
            ws = wb.active
            
            # 验证表头
            headers = [cell.value for cell in ws[1]]
            
            # 灵活的表头匹配
            header_map = {}
            for i, header in enumerate(headers):
                if header:
                    header_lower = str(header).lower().strip()
                    # 精确匹配题目内容，排除题型
                    if 'content' in header_lower or ('题' in header_lower and '题型' not in header_lower):
                        header_map['content'] = i
                    elif 'type' in header_lower or '题型' in header_lower:
                        header_map['type'] = i
                    elif 'a' == header_lower or '选项a' in header_lower:
                        header_map['option_a'] = i
                    elif 'b' == header_lower or '选项b' in header_lower:
                        header_map['option_b'] = i
                    elif 'c' == header_lower or '选项c' in header_lower:
                        header_map['option_c'] = i
                    elif 'd' == header_lower or '选项d' in header_lower:
                        header_map['option_d'] = i
                    elif 'answer' in header_lower or '正确' in header_lower:
                        header_map['correct_answer'] = i
                    elif 'score' in header_lower or '分' in header_lower:
                        header_map['score'] = i
                    elif 'explanation' in header_lower or '解析' in header_lower:
                        header_map['explanation'] = i
            
            # 检查必需列
            required_keys = ['content', 'correct_answer', 'score']
            missing_cols = [k for k in required_keys if k not in header_map]
            if missing_cols:
                messages.error(request, f'缺少必需列：{", ".join(missing_cols)}。请下载正确格式的模板')
                return render(request, 'quiz/frontend/import_test_paper.html')
            
            # 解析数据
            questions_data = []
            errors = []
            
            for row_idx, row in enumerate(ws.iter_rows(min_row=2), start=2):
                try:
                    content = str(row[header_map['content']].value or '').strip()
                    if not content:
                        continue
                    
                    # 处理题型（支持数字和文字）
                    q_type = 1
                    if 'type' in header_map:
                        type_val = row[header_map['type']].value
                        if type_val is not None:
                            type_str = str(type_val).strip()
                            if type_str in ['3', '判断题', '判断', 'judge']:
                                q_type = 3
                            elif type_str in ['2', '多选题', '多选', 'multiple']:
                                q_type = 2
                            elif type_str in ['1', '单选题', '单选', '选择题', '选择', 'choice']:
                                q_type = 1
                    
                    # 处理选项（支持分开的多列和合并的选项列）
                    options = {}
                    option_cols = ['option_a', 'option_b', 'option_c', 'option_d']
                    option_letters = ['A', 'B', 'C', 'D']
                    
                    for col_key, letter in zip(option_cols, option_letters):
                        if col_key in header_map:
                            val = row[header_map[col_key]].value
                            if val and str(val).strip():
                                options[letter] = str(val).strip()
                    
                    # 如果没有单独的选项列，尝试从'选项'列读取
                    if not options and 'options' in header_map:
                        options_str = str(row[header_map['options']].value or '').strip()
                        if options_str:
                            # 格式：A.选项1,B.选项2,C.选项3,D.选项4
                            for item in options_str.split(','):
                                item = item.strip()
                                if item and len(item) >= 2:
                                    letter = item[0].upper()
                                    if letter in ['A', 'B', 'C', 'D']:
                                        options[letter] = item[1:].strip()
                    
                    # 格式化选项为 {"A": "内容", "B": "内容"}
                    options_json = options if options else {}
                    
                    correct_answer = str(row[header_map['correct_answer']].value or '').strip()
                    if not correct_answer:
                        errors.append(f'第{row_idx}行：正确答案为空，请补全')
                    
                    try:
                        score = int(row[header_map['score']].value or '')
                        if score <= 0:
                            score = ''
                    except:
                        score = ''
                        errors.append(f'第{row_idx}行：分值格式错误，请补全')
                    
                    explanation = ''
                    if 'explanation' in header_map:
                        explanation = str(row[header_map['explanation']].value or '').strip()
                    
                    questions_data.append({
                        'content': content,
                        'type': q_type,
                        'options': options_json,
                        'correct_answer': correct_answer,
                        'score': score,
                        'explanation': explanation,
                        'row': row_idx,
                        'has_error': not correct_answer or not score
                    })
                    
                except Exception as e:
                    errors.append(f'第{row_idx}行：{str(e)}')
            
            if not questions_data:
                if errors:
                    for err in errors[:5]:
                        messages.error(request, err)
                else:
                    messages.error(request, '文件中没有有效的题目数据')
                return render(request, 'quiz/frontend/import_test_paper.html')
            
            # 统计有效题目和待补全题目数量
            valid_count = sum(1 for q in questions_data if q.get('correct_answer') and q.get('score'))
            missing_count = len(questions_data) - valid_count
            
            # 返回预览页面
            import json
            # 计算总分，处理空值情况
            total_score = sum(q['score'] if isinstance(q['score'], int) else 0 for q in questions_data)
            return render(request, 'quiz/frontend/import_preview.html', {
                'title': title,
                'description': description,
                'questions_data': questions_data,
                'questions_json': json.dumps(questions_data, ensure_ascii=False),
                'total_score': total_score,
                'valid_count': valid_count,
                'missing_count': missing_count,
                'errors': errors[:10] if errors else []
            })
            
        except InvalidFileException:
            messages.error(request, '文件格式不正确，请上传 .xlsx 格式的 Excel 文件')
        except Exception as e:
            messages.error(request, f'读取文件失败：{str(e)}')
        
        return render(request, 'quiz/frontend/import_test_paper.html')
    
    return render(request, 'quiz/frontend/import_test_paper.html')


@login_required
def publish_test_paper(request, paper_id):
    """发布/取消发布试卷"""
    try:
        paper = TestPaper.objects.get(id=paper_id, created_by=request.user.username)
        paper.is_published = not paper.is_published
        paper.save()
        
        if paper.is_published:
            messages.success(request, f'试卷 "{paper.title}" 已发布')
        else:
            messages.success(request, f'试卷 "{paper.title}" 已取消发布')
    except TestPaper.DoesNotExist:
        messages.error(request, '试卷不存在')
    
    return redirect('my_test_papers')


@login_required
def download_import_template(request):
    """下载导入模板"""
    return download_template_response()


@login_required
def delete_test_paper(request, paper_id):
    """删除试卷"""
    try:
        paper = TestPaper.objects.get(id=paper_id, created_by=request.user.username)
        paper.delete()
        messages.success(request, '试卷已删除')
    except TestPaper.DoesNotExist:
        messages.error(request, '试卷不存在')
    
    return redirect('my_test_papers')


# ========== 后台管理功能 ==========
from django.contrib.admin.views.decorators import staff_member_required
import openpyxl

@staff_member_required
def admin_import_questions(request):
    """后台导入试题 - 使用统一的导入函数"""
    if request.method == 'POST':
        if 'file' in request.FILES:
            file = request.FILES['file']
            questions_data, stats, errors = import_questions_from_excel(file)
            
            if errors:
                messages.error(request, errors[0])
                return render(request, 'quiz/admin/import_questions.html', {'step': 1})
            
            # 为每个题目添加 has_error 和 row 字段（保持与原有模板兼容）
            for idx, q in enumerate(questions_data):
                q['row'] = idx + 2
                q['has_error'] = not (q.get('correct_answer') and q.get('score'))
            
            return render(request, 'quiz/admin/import_questions.html', {
                'step': 2,
                'questions_data': questions_data,
                'questions_json': json.dumps(questions_data, ensure_ascii=False),
                'total_score': stats['total_score'],
                'valid_count': stats['valid_count'],
                'missing_count': stats['missing_count'],
                'errors': stats['errors']
            })
        
        elif 'questions_json' in request.POST:
            try:
                questions_data = json.loads(request.POST['questions_json'])
                imported_count = 0
                
                for q_data in questions_data:
                    if q_data.get('content') and q_data.get('correct_answer') and q_data.get('score'):
                        Question.objects.create(
                            type=q_data['type'],
                            content=q_data['content'],
                            options=q_data.get('options', {}),
                            correct_answer=q_data['correct_answer'],
                            score=q_data['score'],
                            explanation=q_data.get('explanation', '')
                        )
                        imported_count += 1
                
                return render(request, 'quiz/admin/import_questions.html', {
                    'step': 3,
                    'imported_count': imported_count
                })
            
            except Exception as e:
                messages.error(request, f'导入失败：{str(e)}')
                return render(request, 'quiz/admin/import_questions.html', {'step': 1})
    
    return render(request, 'quiz/admin/import_questions.html', {'step': 1})


@staff_member_required
def admin_export_template(request):
    """下载后台导入模板"""
    return download_template_response()


@staff_member_required
def admin_create_testpaper(request):
    """后台组卷"""
    all_questions = Question.objects.all()
    
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        is_published = request.POST.get('is_published') == 'on'
        selected_questions = request.POST.get('selected_questions')
        
        if not title:
            messages.error(request, '请输入试卷标题')
            return render(request, 'quiz/admin/create_testpaper.html', {'all_questions': all_questions})
        
        if not selected_questions:
            messages.error(request, '请选择题目')
            return render(request, 'quiz/admin/create_testpaper.html', {'all_questions': all_questions})
        
        try:
            question_ids = json.loads(selected_questions)
            
            paper = TestPaper.objects.create(
                title=title,
                description=description,
                is_published=is_published,
                created_by=request.user.username,
                source='admin'
            )
            
            for q_id in question_ids:
                try:
                    question = Question.objects.get(id=q_id)
                    paper.questions.add(question)
                except Question.DoesNotExist:
                    pass
            
            paper.save()
            
            messages.success(request, f'试卷 "{title}" 创建成功')
            return redirect('admin:quiz_testpaper_changelist')
        
        except Exception as e:
            messages.error(request, f'创建试卷失败：{str(e)}')
            return render(request, 'quiz/admin/create_testpaper.html', {'all_questions': all_questions})
    
    return render(request, 'quiz/admin/create_testpaper.html', {'all_questions': all_questions})


@staff_member_required
def admin_import_testpaper(request):
    """后台导入试卷 - 从Excel导入试卷（同前端import_test_paper统一的方法）"""
    if request.method == 'POST':
        action = request.POST.get('action', '')
        
        # 处理确认导入
        if action == 'confirm_import':
            title = request.POST.get('title', '')
            description = request.POST.get('description', '')
            questions_json = request.POST.get('questions_data', '')
            
            if title and questions_json:
                try:
                    questions_data = json.loads(questions_json)
                    
                    if not questions_data:
                        messages.error(request, '没有有效的题目数据')
                        return render(request, 'quiz/admin/import_testpaper.html', {'step': 1})
                    
                    test_paper = TestPaper.objects.create(
                        title=title,
                        description=description,
                        created_by=request.user.username,
                        is_published=False,
                        source='admin'
                    )
                    
                    total_score = 0
                    valid_questions = 0
                    for q_data in questions_data:
                        if not q_data.get('content') or not q_data.get('correct_answer'):
                            continue
                        
                        options_data = q_data.get('options', {})
                        if isinstance(options_data, str):
                            try:
                                options_data = json.loads(options_data)
                            except:
                                options_data = {}
                        
                        q_type = int(q_data.get('type', 1))
                        if q_type not in [1, 2, 3]:
                            q_type = 1
                        
                        q_score = q_data.get('score', 1)
                        try:
                            q_score = int(q_score) if q_score else 1
                        except:
                            q_score = 1
                        
                        question = Question.objects.create(
                            type=q_type,
                            content=q_data['content'],
                            options=options_data,
                            correct_answer=q_data['correct_answer'],
                            score=q_score,
                            explanation=q_data.get('explanation', '')
                        )
                        test_paper.questions.add(question)
                        total_score += q_score
                        valid_questions += 1
                    
                    test_paper.total_score = total_score
                    test_paper.save()
                    
                    messages.success(request, f'试卷 "{title}" 导入成功！共导入 {len(questions_data)} 道题目')
                    return redirect('admin:quiz_testpaper_changelist')
                except Exception as e:
                    messages.error(request, f'导入失败：{str(e)}')
            else:
                messages.error(request, '请填写试卷标题并确认导入')
            return render(request, 'quiz/admin/import_testpaper.html', {'step': 1})
        
        # 处理文件上传和预览
        if request.FILES.get('paper_file'):
            title = request.POST.get('title', '')
            description = request.POST.get('description', '')
            file = request.FILES.get('paper_file')
            
            if not title:
                messages.error(request, '请填写试卷标题')
                return render(request, 'quiz/admin/import_testpaper.html', {'step': 1})
            
            try:
                import openpyxl
                from openpyxl.utils.exceptions import InvalidFileException
                
                wb = openpyxl.load_workbook(file)
                ws = wb.active
                
                headers = [cell.value for cell in ws[1]]
                
                header_map = {}
                for i, header in enumerate(headers):
                    if header:
                        header_lower = str(header).lower().strip()
                        if 'content' in header_lower or ('题' in header_lower and '题型' not in header_lower):
                            header_map['content'] = i
                        elif 'type' in header_lower or '题型' in header_lower:
                            header_map['type'] = i
                        elif 'a' == header_lower or '选项a' in header_lower:
                            header_map['option_a'] = i
                        elif 'b' == header_lower or '选项b' in header_lower:
                            header_map['option_b'] = i
                        elif 'c' == header_lower or '选项c' in header_lower:
                            header_map['option_c'] = i
                        elif 'd' == header_lower or '选项d' in header_lower:
                            header_map['option_d'] = i
                        elif 'answer' in header_lower or '正确' in header_lower:
                            header_map['correct_answer'] = i
                        elif 'score' in header_lower or '分' in header_lower:
                            header_map['score'] = i
                        elif 'explanation' in header_lower or '解析' in header_lower:
                            header_map['explanation'] = i
                
                required_keys = ['content', 'correct_answer', 'score']
                missing_cols = [k for k in required_keys if k not in header_map]
                if missing_cols:
                    messages.error(request, f'缺少必需列：{", ".join(missing_cols)}。请下载正确格式的模板')
                    return render(request, 'quiz/admin/import_testpaper.html', {'step': 1})
                
                questions_data = []
                errors = []
                
                for row_idx, row in enumerate(ws.iter_rows(min_row=2), start=2):
                    try:
                        content = str(row[header_map['content']].value or '').strip()
                        if not content:
                            continue
                        
                        q_type = 1
                        if 'type' in header_map:
                            type_val = row[header_map['type']].value
                            if type_val is not None:
                                type_str = str(type_val).strip()
                                if type_str in ['3', '判断题', '判断', 'judge']:
                                    q_type = 3
                                elif type_str in ['2', '多选题', '多选', 'multiple']:
                                    q_type = 2
                                elif type_str in ['1', '单选题', '单选', '选择题', '选择', 'choice']:
                                    q_type = 1
                        
                        options = {}
                        option_cols = ['option_a', 'option_b', 'option_c', 'option_d']
                        option_letters = ['A', 'B', 'C', 'D']
                        
                        for col_key, letter in zip(option_cols, option_letters):
                            if col_key in header_map:
                                val = row[header_map[col_key]].value
                                if val and str(val).strip():
                                    options[letter] = str(val).strip()
                        
                        if not options and 'options' in header_map:
                            options_str = str(row[header_map['options']].value or '').strip()
                            if options_str:
                                for item in options_str.split(','):
                                    item = item.strip()
                                    if item and len(item) >= 2:
                                        letter = item[0].upper()
                                        if letter in ['A', 'B', 'C', 'D']:
                                            options[letter] = item[1:].strip()
                        
                        options_json = options if options else {}
                        
                        correct_answer = str(row[header_map['correct_answer']].value or '').strip()
                        if not correct_answer:
                            errors.append(f'第{row_idx}行：正确答案为空，请补全')
                        
                        try:
                            score = int(row[header_map['score']].value or '')
                            if score <= 0:
                                score = ''
                        except:
                            score = ''
                            errors.append(f'第{row_idx}行：分值格式错误，请补全')
                        
                        explanation = ''
                        if 'explanation' in header_map:
                            explanation = str(row[header_map['explanation']].value or '').strip()
                        
                        questions_data.append({
                            'content': content,
                            'type': q_type,
                            'options': options_json,
                            'correct_answer': correct_answer,
                            'score': score,
                            'explanation': explanation,
                            'row': row_idx,
                            'has_error': not correct_answer or not score
                        })
                        
                    except Exception as e:
                        errors.append(f'第{row_idx}行：{str(e)}')
                
                if not questions_data:
                    if errors:
                        for err in errors[:5]:
                            messages.error(request, err)
                    else:
                        messages.error(request, '文件中没有有效的题目数据')
                    return render(request, 'quiz/admin/import_testpaper.html', {'step': 1})
                
                valid_count = sum(1 for q in questions_data if q.get('correct_answer') and q.get('score'))
                missing_count = len(questions_data) - valid_count
                total_score = sum(q['score'] if isinstance(q['score'], int) else 0 for q in questions_data)
                
                return render(request, 'quiz/admin/import_testpaper.html', {
                    'step': 2,
                    'title': title,
                    'description': description,
                    'questions_data': questions_data,
                    'questions_json': json.dumps(questions_data, ensure_ascii=False),
                    'total_score': total_score,
                    'valid_count': valid_count,
                    'missing_count': missing_count,
                    'errors': errors[:10] if errors else []
                })
                
            except InvalidFileException:
                messages.error(request, '文件格式不正确，请上传 .xlsx 格式的 Excel 文件')
            except Exception as e:
                messages.error(request, f'读取文件失败：{str(e)}')
            
            return render(request, 'quiz/admin/import_testpaper.html', {'step': 1})
    
    return render(request, 'quiz/admin/import_testpaper.html', {'step': 1})


@staff_member_required
def admin_preview_testpaper(request, paper_id):
    """后台试卷预览"""
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    questions = test_paper.questions.all()
    
    question_list = []
    for idx, q in enumerate(questions, start=1):
        type_name = {1: '单选题', 2: '多选题', 3: '判断题'}.get(q.type, '未知')
        options_list = []
        if q.options:
            for letter in ['A', 'B', 'C', 'D']:
                val = q.options.get(letter, '')
                if val:
                    options_list.append({'letter': letter, 'content': val})
        
        question_list.append({
            'seq': idx,
            'id': q.id,
            'type': q.type,
            'type_name': type_name,
            'content': q.content,
            'options': options_list,
            'correct_answer': q.correct_answer,
            'score': q.score,
            'explanation': q.explanation,
        })
    
    context = {
        'test_paper': test_paper,
        'question_list': question_list,
        'total_questions': len(question_list),
        'total_score': test_paper.total_score,
    }
    return render(request, 'quiz/admin/preview_testpaper.html', context)
