import os
import sys
import pandas as pd

# 配置Django环境
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'need_to_do.settings')
import django
django.setup()

from quiz.models import Question

def verify_options():
    # 读取Excel文件
    excel_file = 'quiz/test_questions.xlsx'
    try:
        df = pd.read_excel(excel_file, engine='openpyxl')
        print(f"成功读取Excel文件，共 {len(df)} 行数据")
    except Exception as e:
        print(f"读取Excel文件失败: {e}")
        return
    
    # 验证前5行数据
    for i in range(5):
        row = df.iloc[i]
        question_content = row.get('题目', '')
        if not question_content:
            continue
        
        # 获取数据库中的题目
        try:
            questions = Question.objects.filter(content=question_content)
        except Exception as e:
            print(f"Excel中第 {i+1} 行题目查询失败: {question_content}, 错误: {e}")
            continue
        
        # 比较选项
        excel_options = {}
        for option_key in ['A', 'B', 'C', 'D']:
            ch_column_name = f'选项{option_key}'
            if ch_column_name in row and pd.notnull(row[ch_column_name]):
                excel_options[option_key] = row[ch_column_name]
        
        print(f"Excel第 {i+1} 行:")
        print(f"题目: {question_content}")
        print(f"Excel选项: {excel_options}")
        print(f"Excel正确答案: {row.get('正确选项', '')}")
        print(f"数据库中找到 {questions.count()} 个匹配的题目")
        
        for j, question in enumerate(questions):
            db_options = question.options or {}
            print(f"  第 {j+1} 个匹配题:")
            print(f"    ID: {question.id}")
            print(f"    选项: {db_options}")
            print(f"    正确答案: {question.correct_answer}")
            print(f"    选项是否匹配: {excel_options == db_options}")
            print(f"    正确答案是否匹配: {row.get('正确选项', '') == question.correct_answer}")
        
        print("--------------------------------------------------")

if __name__ == '__main__':
    verify_options()