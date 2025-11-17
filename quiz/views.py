from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse
from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from .models import Question, TestPaper
import pandas as pd
import json

# 题目列表视图
def question_list(request):
    questions = Question.objects.all()
    return render(request, 'quiz/frontend/question_list.html', {'questions': questions})

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

def import_questions(request):
    if request.method == 'POST':
        # 处理文件上传
        excel_file = request.FILES.get('excel_file')
        if not excel_file:
            return HttpResponse("请选择一个Excel文件上传", status=400)
        
        # 解析Excel文件
        df = pd.read_excel(excel_file)
        
        # 遍历每行数据，创建题目
        for index, row in df.iterrows():
            try:
                # 转换选项为JSON格式
                options = {}
                if '选项A' in row and pd.notnull(row['选项A']):
                    options['A'] = row['选项A']
                if '选项B' in row and pd.notnull(row['选项B']):
                    options['B'] = row['选项B']
                if '选项C' in row and pd.notnull(row['选项C']):
                    options['C'] = row['选项C']
                if '选项D' in row and pd.notnull(row['选项D']):
                    options['D'] = row['选项D']
                
                # 处理题型：支持数字或字符串格式
                question_type = row['题型']
                try:
                    # 先尝试转换为整数
                    question_type_int = int(question_type)
                    # 验证是否是有效题型
                    if question_type_int not in [1, 2]:
                        raise ValueError(f"不支持的题型: {question_type_int}")
                except ValueError:
                    # 如果转换失败，使用字符串映射
                    type_mapping = {
                        '单项选择题': 1,
                        '选择题': 1,
                        '判断题': 2
                    }
                    if question_type not in type_mapping:
                        raise ValueError(f"不支持的题型: {question_type}")
                    question_type_int = type_mapping[question_type]
                
                # 创建Question对象
                question = Question(
                    type=question_type_int,
                    content=row['题目'],
                    options=options if options else None,
                    correct_answer=row['正确选项'],
                    score=row.get('分值', 1),
                    explanation=row.get('解析', ''),
                )
                question.save()
            except Exception as e:
                return HttpResponse(f"导入第{index+1}行数据失败: {str(e)}", status=500)
        
        return redirect('question_list')
    
    return render(request, 'quiz/backend/import_questions.html')

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
    return render(request, 'quiz/frontend/test_paper_detail.html', {'test_paper': test_paper})

# 试卷提交处理视图
def submit_test_paper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    if request.method == 'POST':
        total_score = 0
        user_answers = {}
        correct_count = 0
        question_results = []
        
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
