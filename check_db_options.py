import os
import django

# 设置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'need_to_do.settings')
django.setup()

from quiz.models import Question

# 获取前10道题目
questions = Question.objects.all()[:10]
print(f"共有 {Question.objects.count()} 道题目")

# 打印每道题的详细信息
for q in questions:
    print(f"\n题目ID: {q.id}")
    print(f"题型: {q.type} (1=选择题, 2=判断题)")
    print(f"题目: {q.content}")
    print(f"选项: {q.options}")
    print(f"正确答案: {q.correct_answer}")
    print(f"选项类型: {type(q.options)}")
    print(f"选项键: {list(q.options.keys())}")
    print(f"是否有选项A: {'A' in q.options}")
    print(f"是否有选项B: {'B' in q.options}")
    print(f"是否有选项C: {'C' in q.options}")
    print(f"是否有选项D: {'D' in q.options}")
    print("-" * 50)