import os
import sys
import pandas as pd

# 配置Django环境
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'need_to_do.settings')
import django
django.setup()

from quiz.models import Question

def check_duplicate_questions():
    # 获取所有题目内容和对应的数量
    all_questions = Question.objects.values_list('content', flat=True)
    
    # 统计重复的题目
    content_counts = {}
    for content in all_questions:
        if content in content_counts:
            content_counts[content] += 1
        else:
            content_counts[content] = 1
    
    # 找出重复的题目
    duplicate_questions = {content: count for content, count in content_counts.items() if count > 1}
    
    print(f"数据库中共有 {len(all_questions)} 道题目")
    print(f"其中有 {len(duplicate_questions)} 道题目存在重复")
    
    if duplicate_questions:
        print("前10道重复的题目:")
        for i, (content, count) in enumerate(list(duplicate_questions.items())[:10]):
            print(f"{i+1}. {content[:50]}... (重复 {count} 次)")
    
    # 检查第一个重复题目的具体ID
    if duplicate_questions:
        first_duplicate = list(duplicate_questions.keys())[0]
        questions = Question.objects.filter(content=first_duplicate)
        print(f"\n第一个重复题目的具体ID: {[q.id for q in questions]}")

if __name__ == '__main__':
    check_duplicate_questions()