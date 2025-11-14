from django.contrib import admin
from django.contrib import messages
from django.http import HttpResponseRedirect
from django.urls import reverse
from django import forms
from .models import Question, TestPaper
import pandas as pd
import json

class ImportQuestionsForm(forms.Form):
    excel_file = forms.FileField(label='Excel文件')

class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'type', 'content', 'score', 'created_at')
    list_filter = ('type', 'created_at')
    search_fields = ('content', 'explanation')
    ordering = ('-created_at',)
    
    # 在管理界面添加批量导入按钮
    def changelist_view(self, request, extra_context=None):
        extra_context = extra_context or {}
        extra_context['import_form'] = ImportQuestionsForm()
        return super().changelist_view(request, extra_context=extra_context)

    # 处理批量导入的POST请求
    def post(self, request, *args, **kwargs):
        if 'excel_file' in request.FILES:
            excel_file = request.FILES['excel_file']
            try:
                # 解析Excel文件
                df = pd.read_excel(excel_file)
                
                # 遍历每行数据，创建题目
                for index, row in df.iterrows():
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
                
                messages.success(request, f'成功导入{len(df)}道题目')
            except Exception as e:
                messages.error(request, f'导入失败: {str(e)}')
            return HttpResponseRedirect(reverse('admin:quiz_question_changelist'))
        
        # 如果不是导入请求，调用父类的POST方法
        return super().post(request, *args, **kwargs)

class TestPaperAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'total_score', 'is_published', 'created_by', 'created_at')
    list_filter = ('is_published', 'created_at')
    search_fields = ('title', 'description')
    ordering = ('-created_at',)
    filter_horizontal = ('questions',)  # 多对多关系使用水平选择器
    change_form_template = 'quiz/testpaper/change_form.html'  # 使用自定义模板

admin.site.register(Question, QuestionAdmin)
admin.site.register(TestPaper, TestPaperAdmin)
