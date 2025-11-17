import os
import sys
import django

# 设置Django环境
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "need_to_do.settings")
django.setup()

from quiz.models import Question

print("=== 检查数据库中题目的选项存储情况 ===")

# 获取所有题目
questions = Question.objects.all()
print(f"共有 {questions.count()} 道题目")

for question in questions[:5]:  # 只检查前5道题目
    print(f"\n题目ID: {question.id}")
    print(f"题目类型: {question.type}")
    print(f"题目内容: {question.content}")
    print(f"选项: {question.options}")
    print(f"选项类型: {type(question.options)}")
    print(f"正确答案: {question.correct_answer}")
    
    # 检查选项键是否存在
    print(f"是否有选项A: {'A' in question.options}")
    print(f"是否有选项B: {'B' in question.options}")
    print(f"是否有选项C: {'C' in question.options}")
    print(f"是否有选项D: {'D' in question.options}")

# 检查是否有题目没有选项
questions_without_options = questions.filter(options__in=[{}, None])
print(f"\n没有选项的题目数量: {questions_without_options.count()}")

# 检查是否有选择题没有选项
mc_questions = questions.filter(type=1)
mc_questions_without_options = mc_questions.filter(options__in=[{}, None])
print(f"选择题没有选项的数量: {mc_questions_without_options.count()}")

# 检查是否有判断题没有选项
if_questions = questions.filter(type=2)
if_questions_without_options = if_questions.filter(options__in=[{}, None])
print(f"判断题没有选项的数量: {if_questions_without_options.count()}")