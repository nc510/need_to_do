import pandas as pd

# 定义Excel文件路径
excel_file_path = 'd:\\FF\\000耿老师\\code\\AI_Code\\Need_To_Do\\need_to_do\\quiz\\test_questions.xlsx'

try:
    # 读取Excel文件
    df = pd.read_excel(excel_file_path, engine='openpyxl')
    
    # 打印基本信息
    print("Excel文件读取成功")
    print(f"行数: {len(df)}")
    print(f"列数: {len(df.columns)}")
    
    print("\n列名:")
    for col in df.columns:
        print(f"- {col!r}")
        print(f"  长度: {len(col)}")
        print(f"  ASCII值: {[ord(c) for c in col]}")
    
    print("\n前5行数据:")
    print(df.head())
    
    # 检查是否有选项相关列
    print("\n检查选项列:")
    option_columns = [col for col in df.columns if '选项' in col or col in ['A', 'B', 'C', 'D']]
    print(f"找到的选项列: {option_columns}")
    
    # 尝试使用不同的方式检查列名（针对可能的隐形字符问题）
    print("\n尝试使用模糊匹配查找选项列:")
    for col in df.columns:
        if any(keyword in col for keyword in ['选项', 'Option', 'option']):
            print(f"- {col!r}")
    
    if option_columns:
        print("\n选项列数据示例:")
        print(df[option_columns].head())
    
    # 检查特定列是否存在
    print("\n检查特定列是否存在:")
    check_cols = ['选项A', '选项B', '选项C', '选项D']
    for col in check_cols:
        if col in df.columns:
            print(f"- {col!r} 存在")
            # 检查该列的数据类型
            print(f"  数据类型: {df[col].dtype}")
            # 检查是否有非空数据
            non_empty_count = df[col].notnull().sum()
            print(f"  非空值数量: {non_empty_count}")
            if non_empty_count > 0:
                # 打印前几个非空值
                print(f"  非空值示例: {df[col].dropna().head().tolist()}")
        else:
            print(f"- {col!r} 不存在")
            
except Exception as e:
    print(f"Excel文件读取失败: {e}")
    import traceback
    traceback.print_exc()