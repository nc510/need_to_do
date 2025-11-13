from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse
from .models import Question
import pandas as pd
import json

# 题目列表视图
def question_list(request):
    questions = Question.objects.all()
    return render(request, 'quiz/question_list.html', {'questions': questions})

# 答题视图
def question_detail(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    if request.method == 'POST':
        user_answer = request.POST.get('answer')
        if user_answer == question.correct_answer:
            result = '正确'
        else:
            result = '错误'
        return render(request, 'quiz/answer_result.html', {
            'question': question,
            'user_answer': user_answer,
            'result': result,
            'correct_answer': question.correct_answer
        })
    return render(request, 'quiz/question_detail.html', {'question': question})

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
    
    return render(request, 'quiz/import_questions.html')
