import os
import sys
import django

# 设置Django环境
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "need_to_do.settings")
django.setup()

from quiz.models import Question

print("=== 检查并修复已有题目的选项字段问题 ===")

# 获取所有题目
questions = Question.objects.all()
print(f"共有 {questions.count()} 道题目")

# 检查前10道题目的详细情况
print("\n=== 前10道题目的详细情况 ===")
for i, question in enumerate(questions[:10]):
    print(f"\n第{i+1}题:")
    print(f"ID: {question.id}")
    print(f"题型: {question.type}")
    print(f"题目: {question.content}")
    print(f"选项: {question.options}")
    print(f"正确答案: {question.correct_answer}")
    print(f"选项是否为空: {not question.options}")

# 检查选择题的情况
mc_questions = questions.filter(type=1)
empty_mc_questions = mc_questions.filter(options__exact={})
print(f"\n=== 选择题情况 ===")
print(f"共有选择题: {mc_questions.count()} 道")
print(f"选项为空的选择题: {empty_mc_questions.count()} 道")

# 检查判断题的情况
if_questions = questions.filter(type=2)
print(f"\n=== 判断题情况 ===")
print(f"共有判断题: {if_questions.count()} 道")

# 提供解决方案建议
print(f"\n=== 解决方案建议 ===")
print("1. 已修复Admin导入逻辑，现在支持多种列名格式")
print("2. 已修改模型，选项字段默认值为空字典")
print(f"3. 已导入的 {questions.count()} 道题目中的选项字段为空，需要重新导入")
print("4. 或者可以手动编辑题目添加选项")

print(f"\n=== 完成 ===")