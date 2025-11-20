import os
import sys
import pandas as pd

# 配置Django环境
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'need_to_do.settings')
import django
django.setup()

from quiz.models import Question

def update_all_options_from_excel():
    # 读取Excel文件
    excel_file = 'quiz/test_questions.xlsx'
    try:
        df = pd.read_excel(excel_file, engine='openpyxl')
        print(f"成功读取Excel文件，共 {len(df)} 行数据")
    except Exception as e:
        print(f"读取Excel文件失败: {e}")
        return
    
    updated_count = 0
    skipped_count = 0
    
    # 创建Excel数据字典：题目内容 -> 选项
    excel_data = {}
    for _, row in df.iterrows():
        question_content = row.get('题目', '')
        if not question_content:
            skipped_count += 1
            continue
        
        # 转换选项为JSON格式
        options = {}
        for option_key in ['A', 'B', 'C', 'D']:
            ch_column_name = f'选项{option_key}'
            if ch_column_name in row and pd.notnull(row[ch_column_name]):
                options[option_key] = row[ch_column_name]
        
        if options:
            excel_data[question_content] = options
    
    print(f"从Excel中提取到 {len(excel_data)} 道有选项的题目")
    
    # 获取所有题目
    all_questions = Question.objects.all()
    print(f"从数据库中获取到 {all_questions.count()} 道题目")
    
    # 遍历所有题目，根据内容匹配选项
    for question in all_questions:
        if question.content in excel_data:
            question.options = excel_data[question.content]
            question.save()
            updated_count += 1
            if updated_count % 100 == 0:
                print(f"已更新 {updated_count} 道题目的选项")
    
    print(f"更新完成！")
    print(f"成功更新 {updated_count} 道题目的选项")
    print(f"跳过 {skipped_count} 行无题目内容的数据")

if __name__ == '__main__':
    update_all_options_from_excel()