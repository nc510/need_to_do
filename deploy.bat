@echo off
setlocal

:: ================================================
:: 在线考试系统 - 部署脚本
:: ================================================

echo.
echo ================================================
echo        在线考试系统部署脚本
echo ================================================
echo.

:: 检查 Python 是否安装
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python 未安装或未添加到环境变量
    pause
    exit /b 1
)

:: 检查虚拟环境是否存在
if not exist "venv" (
    echo [INFO] 创建虚拟环境...
    python -m venv venv
    if %errorlevel% neq 0 (
        echo [ERROR] 创建虚拟环境失败
        pause
        exit /b 1
    )
)

:: 激活虚拟环境
echo [INFO] 激活虚拟环境...
call venv\Scripts\activate.bat

:: 安装依赖
echo [INFO] 安装依赖包...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] 安装依赖失败
    pause
    exit /b 1
)

:: 执行数据库迁移
echo [INFO] 执行数据库迁移...
python manage.py migrate
if %errorlevel% neq 0 (
    echo [ERROR] 数据库迁移失败
    pause
    exit /b 1
)

:: 收集静态文件
echo [INFO] 收集静态文件...
python manage.py collectstatic --noinput
if %errorlevel% neq 0 (
    echo [ERROR] 收集静态文件失败
    pause
    exit /b 1
)

echo.
echo ================================================
echo         部署完成！
echo ================================================
echo.
echo 启动命令：
echo   python run.py
echo.
echo 访问地址：
echo   http://localhost:8090/quiz/test_paper_list/
echo.
pause