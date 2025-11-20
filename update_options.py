import os
import django

# 设置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'need_to_do.settings')
django.setup()

from quiz.models import Question

# 更新所有选项为None的问题
questions = Question.objects.filter(options=None)
count = questions.count()
questions.update(options={})
print(f'已更新 {count} 个问题的选项字段，将None改为空字典')

# 验证更新结果
questions_after = Question.objects.filter(options=None)
print(f'更新后仍有 {questions_after.count()} 个问题的选项字段为None')