"""
清除题目和试卷数据，保留用户注册数据
"""
import os
import django

# 配置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'need_to_do.settings')
django.setup()

from quiz.models import (
    Question, TestPaper, TestRecord, AnswerRecord, WrongQuestion,
    ClassAssignment, ClassAssignmentRecord, Subject, Chapter, Section, KnowledgePoint
)

def clear_data():
    print('开始清除数据...')
    
    # 清除答题相关记录
    print('清除班级作业记录...')
    count = ClassAssignmentRecord.objects.count()
    ClassAssignmentRecord.objects.all().delete()
    print(f'  已清除 {count} 条班级作业记录')
    
    print('清除班级作业...')
    count = ClassAssignment.objects.count()
    ClassAssignment.objects.all().delete()
    print(f'  已清除 {count} 个班级作业')
    
    print('清除每题答题记录...')
    count = AnswerRecord.objects.count()
    AnswerRecord.objects.all().delete()
    print(f'  已清除 {count} 条每题答题记录')
    
    print('清除答题记录...')
    count = TestRecord.objects.count()
    TestRecord.objects.all().delete()
    print(f'  已清除 {count} 条答题记录')
    
    print('清除错题本...')
    count = WrongQuestion.objects.count()
    WrongQuestion.objects.all().delete()
    print(f'  已清除 {count} 条错题记录')
    
    print('清除试卷...')
    count = TestPaper.objects.count()
    TestPaper.objects.all().delete()
    print(f'  已清除 {count} 份试卷')
    
    print('清除题目...')
    count = Question.objects.count()
    Question.objects.all().delete()
    print(f'  已清除 {count} 道题目')
    
    print('清除知识点...')
    count = KnowledgePoint.objects.count()
    KnowledgePoint.objects.all().delete()
    print(f'  已清除 {count} 个知识点')
    
    print('清除小节...')
    count = Section.objects.count()
    Section.objects.all().delete()
    print(f'  已清除 {count} 个小节')
    
    print('清除章节...')
    count = Chapter.objects.count()
    Chapter.objects.all().delete()
    print(f'  已清除 {count} 个章节')
    
    print('清除学科...')
    count = Subject.objects.count()
    Subject.objects.all().delete()
    print(f'  已清除 {count} 个学科')
    
    print('\n数据清除完成！')
    print('用户注册数据已保留。')

if __name__ == '__main__':
    clear_data()