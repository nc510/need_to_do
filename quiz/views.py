from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse
from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import IntegrityError
from django.contrib.auth.models import User
from .models import Question, TestPaper, Profile, TestRecord, AnswerRecord, WrongQuestion
import pandas as pd
import json

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
    test_papers = TestPaper.objects.filter(is_published=True).order_by('-created_at')
    # 实现分页，每页显示20套试卷
    paginator = Paginator(test_papers, 20)
    page_num = request.GET.get('page')
    try:
        paginated_test_papers = paginator.page(page_num)
    except PageNotAnInteger:
        # 如果页码不是整数，返回第一页
        paginated_test_papers = paginator.page(1)
    except EmptyPage:
        # 如果页码超出范围，返回最后一页
        paginated_test_papers = paginator.page(paginator.num_pages)
    return render(request, 'quiz/frontend/test_paper_list.html', {'test_papers': paginated_test_papers})

# 试卷详情视图
def test_paper_detail(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    # 确保只显示已发布的试卷
    if not test_paper.is_published:
        return redirect('test_paper_list')
    
    # 检查用户是否登录
    if not request.user.is_authenticated:
        # 未登录用户跳转到注册页面
        return redirect('register')
    
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
                is_correct=is_correct
            )
        
        # 将错题添加到错题本
        for question in wrong_questions:
            try:
                WrongQuestion.objects.create(user=request.user, question=question)
            except IntegrityError:
                # 如果错题已经存在于错题本中，忽略
                pass
        
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
        email = request.POST.get('email')
        
        if not username or not password or not email:
            messages.error(request, '请填写完整的注册信息')
            return render(request, 'quiz/frontend/register.html')
        
        try:
            # 创建用户
            user = User.objects.create_user(
                username=username,
                password=password,
                email=email
            )
            messages.success(request, '注册成功，请等待管理员审核')
            return redirect('login')
        except IntegrityError:
            messages.error(request, '用户名已存在')
            return render(request, 'quiz/frontend/register.html')
    
    return render(request, 'quiz/frontend/register.html')

# 登录视图
def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            messages.success(request, '登录成功')
            return redirect('test_paper_list')
        else:
            messages.error(request, '用户名或密码错误')
            return render(request, 'quiz/frontend/login.html')
    
    return render(request, 'quiz/frontend/login.html')

# 退出登录视图
def logout_view(request):
    logout(request)
    messages.success(request, '已退出登录')
    return redirect('test_paper_list')

# 用户中心视图
@login_required
def user_center(request):
    return render(request, 'quiz/frontend/user_center.html')

# 答题历史记录视图
@login_required
def test_history(request):
    # 获取当前用户的所有答题记录
    test_records = TestRecord.objects.filter(user=request.user).order_by('-completed_at')
    
    # 实现分页
    paginator = Paginator(test_records, 10)  # 每页显示10条记录
    page_num = request.GET.get('page')
    
    try:
        paginated_records = paginator.page(page_num)
    except PageNotAnInteger:
        paginated_records = paginator.page(1)
    except EmptyPage:
        paginated_records = paginator.page(paginator.num_pages)
    
    return render(request, 'quiz/frontend/test_history.html', {
        'test_records': paginated_records
    })

# 错题本视图
@login_required
def wrong_question_notebook(request):
    # 获取当前用户的所有错题
    wrong_questions = WrongQuestion.objects.filter(user=request.user).order_by('-added_at')
    
    # 实现分页
    paginator = Paginator(wrong_questions, 10)  # 每页显示10条错题
    page_num = request.GET.get('page')
    
    try:
        paginated_wrong_questions = paginator.page(page_num)
    except PageNotAnInteger:
        paginated_wrong_questions = paginator.page(1)
    except EmptyPage:
        paginated_wrong_questions = paginator.page(paginator.num_pages)
    
    return render(request, 'quiz/frontend/wrong_question_notebook.html', {
        'wrong_questions': paginated_wrong_questions
    })

# 错题本组卷视图
@login_required
def create_wrong_question_paper(request):
    # 获取当前用户的所有错题
    wrong_questions = WrongQuestion.objects.filter(user=request.user)
    
    if wrong_questions.count() == 0:
        messages.info(request, '您的错题本中没有题目')
        return redirect('wrong_question_notebook')
    
    return render(request, 'quiz/frontend/wrong_question_paper.html', {
        'wrong_questions': wrong_questions
    })

# 错题本试卷提交视图
@login_required
def submit_wrong_question_paper(request):
    if request.method == 'POST':
        total_score = 0
        correct_count = 0
        question_results = []
        wrong_questions_to_remove = []  # 用于收集已经答对的错题
        
        # 获取所有题目ID
        question_ids = request.POST.getlist('question_id')
        
        for question_id in question_ids:
            question = get_object_or_404(Question, pk=question_id)
            user_answer = request.POST.get(f'question_{question_id}')
            
            # 检查用户答案是否正确
            if user_answer and user_answer.strip().lower() == question.correct_answer.strip().lower():
                is_correct = True
                total_score += question.score
                correct_count += 1
                result = '正确'
                wrong_questions_to_remove.append(question)  # 答对的错题可以移除
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
                'score': question.score
            })
        
        total_questions = len(question_ids)
        wrong_count = total_questions - correct_count
        
        # 移除已经答对的错题
        for question in wrong_questions_to_remove:
            WrongQuestion.objects.filter(user=request.user, question=question).delete()
        
        return render(request, 'quiz/frontend/wrong_question_paper_result.html', {
            'total_score': total_score,
            'correct_count': correct_count,
            'wrong_count': wrong_count,
            'total_questions': total_questions,
            'question_results': question_results
        })
    
    return redirect('create_wrong_question_paper')
