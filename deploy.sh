#!/usr/bin/env bash

# ================================================
# 在线考试系统 - Linux/Mac 部署脚本
# ================================================

echo ""
echo "================================================"
echo "        在线考试系统部署脚本"
echo "================================================"
echo ""

# 检查 Python 是否安装
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python3 未安装"
    exit 1
fi

# 检查虚拟环境是否存在
if [ ! -d "venv" ]; then
    echo "[INFO] 创建虚拟环境..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "[ERROR] 创建虚拟环境失败"
        exit 1
    fi
fi

# 激活虚拟环境
echo "[INFO] 激活虚拟环境..."
source venv/bin/activate

# 安装依赖
echo "[INFO] 安装依赖包..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "[ERROR] 安装依赖失败"
    exit 1
fi

# 执行数据库迁移
echo "[INFO] 执行数据库迁移..."
python manage.py migrate
if [ $? -ne 0 ]; then
    echo "[ERROR] 数据库迁移失败"
    exit 1
fi

# 收集静态文件
echo "[INFO] 收集静态文件..."
python manage.py collectstatic --noinput
if [ $? -ne 0 ]; then
    echo "[ERROR] 收集静态文件失败"
    exit 1
fi

echo ""
echo "================================================"
echo "         部署完成！"
echo "================================================"
echo ""
echo "启动命令："
echo "  python run.py"
echo ""
echo "访问地址："
echo "  http://localhost:8090/quiz/test_paper_list/"
echo ""