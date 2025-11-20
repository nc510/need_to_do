import os
import sys
import pandas as pd

# 配置Django环境
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'need_to_do.settings')
import django
django.setup()

from quiz.models import Question

def update_options_from_excel():
    # 读取Excel文件
    excel_file = 'quiz/test_questions.xlsx'
    try:
        df = pd.read_excel(excel_file, engine='openpyxl')
        print(f"成功读取Excel文件，共 {len(df)} 行数据")
    except Exception as e:
        print(f"读取Excel文件失败: {e}")
        return
    
    updated_count = 0
    not_found_count = 0
    
    for index, row in df.iterrows():
        question_content = row.get('题目', '')
        if not question_content:
            continue
        
        # 获取当前行的所有选项
        options = {}
        for option_key in ['A', 'B', 'C', 'D']:
            ch_column_name = f'选项{option_key}'
            if ch_column_name in row and pd.notnull(row[ch_column_name]):
                options[option_key] = row[ch_column_name]
            elif option_key in row and pd.notnull(row[option_key]):
                options[option_key] = row[option_key]
            elif f'Option {option_key}' in row and pd.notnull(row[f'Option {option_key}']):
                options[option_key] = row[f'Option {option_key}']
            elif f'option_{option_key}' in row and pd.notnull(row[f'option_{option_key}']):
                options[option_key] = row[f'option_{option_key}']
        
        if not options:
            continue
        
        try:
            # 根据题目内容找到对应的Question对象
            question = Question.objects.get(content=question_content)
            # 更新选项
            question.options = options
            question.save()
            updated_count += 1
            if updated_count % 50 == 0:
                print(f"已更新 {updated_count} 道题目的选项")
        except Question.DoesNotExist:
            not_found_count += 1
            continue
        except Exception as e:
            print(f"更新题目 '{question_content}' 选项失败: {e}")
            continue
    
    print(f"更新完成！")
    print(f"成功更新 {updated_count} 道题目的选项")
    print(f"未找到 {not_found_count} 道题目")

if __name__ == '__main__':
    update_options_from_excel()