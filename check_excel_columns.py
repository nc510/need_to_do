import pandas as pd

# 读取Excel文件，指定引擎
df = pd.read_excel('quiz/test_questions.xlsx', engine='openpyxl')

# 打印列名
print('列名：')
for col in df.columns:
    print(f'- "{col}"')

# 打印前3行数据
print('\n前3行数据：')
print(df.head(3))

# 检查是否有选项相关的列
print('\n选项相关列检查：')
for option_key in ['A', 'B', 'C', 'D']:
    ch_column_name = f'选项{option_key}'
    en_column_name = option_key
    option_column_name = f'Option {option_key}'
    underscore_column_name = f'option_{option_key}'
    
    print(f'\n检查选项{option_key}相关列：')
    if ch_column_name in df.columns:
        print(f'- "{ch_column_name}" 存在')
        print(f'  样本数据：{df[ch_column_name].head(3).tolist()}')
    if en_column_name in df.columns:
        print(f'- "{en_column_name}" 存在')
        print(f'  样本数据：{df[en_column_name].head(3).tolist()}')
    if option_column_name in df.columns:
        print(f'- "{option_column_name}" 存在')
        print(f'  样本数据：{df[option_column_name].head(3).tolist()}')
    if underscore_column_name in df.columns:
        print(f'- "{underscore_column_name}" 存在')
        print(f'  样本数据：{df[underscore_column_name].head(3).tolist()}')