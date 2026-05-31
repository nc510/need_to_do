@echo off
chcp 65001 >nul
title 在线考试系统 - 重启服务

echo ============================================
echo   📚 在线考试系统 - 重启服务脚本
echo ============================================
echo.

:: =============================================
:: 1. 停止已有的 Waitress 进程（端口 8000）
:: =============================================
echo [1/4] 正在停止 Waitress 后端服务...
for /f "tokens=5" %%i in ('netstat -ano ^| findstr :8000') do (
    if not "%%i"=="" (
        taskkill /f /pid %%i >nul 2>&1
        echo   ✅ 已终止等待中的进程 (PID: %%i)
    )
)
timeout /t 2 /nobreak >nul

:: =============================================
:: 2. 重新加载 Nginx 配置
:: =============================================
echo [2/4] 正在重新加载 Nginx 配置...
C:\nginx-1.29.3\nginx.exe -s reload >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   ✅ Nginx 配置已重新加载
) else (
    echo   ⚠️  Nginx 热重载失败，尝试重新启动...
    taskkill /f /im nginx.exe >nul 2>&1
    timeout /t 1 /nobreak >nul
    start /B C:\nginx-1.29.3\nginx.exe
    echo   ✅ Nginx 已重新启动
)
timeout /t 1 /nobreak >nul

:: =============================================
:: 3. 收集静态文件（刷新 staticfiles）
:: =============================================
echo [3/4] 正在收集静态文件...
cd /d D:\CODE\Need_To_Do
python manage.py collectstatic --noinput >nul 2>&1
echo   ✅ 静态文件已更新

:: =============================================
:: 4. 启动 Waitress 后端
:: =============================================
echo [4/4] 正在启动 Waitress 后端服务...
start /B python run.py
timeout /t 3 /nobreak >nul

:: =============================================
:: 验证服务状态
:: =============================================
echo.
echo ============================================
echo   🔍 验证服务状态
echo ============================================
echo.

:: 检查 Nginx
netstat -ano | findstr :8090 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   ✅ Nginx 已启动 (端口 8090)
) else (
    echo   ❌ Nginx 启动失败
)

:: 检查 Waitress
netstat -ano | findstr :8000 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   ✅ Waitress 已启动 (端口 8000)
) else (
    echo   ❌ Waitress 启动失败
)

:: 检查后台页面是否可访问
timeout /t 2 /nobreak >nul
curl -s -o nul -w "%%{http_code}" http://127.0.0.1:8090/admin/login/ >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   ✅ 后台页面可正常访问
) else (
    echo   ⚠️  后台页面尚在启动中，请稍后刷新
)

echo.
echo ============================================
echo   🎉 服务重启完成！
echo.
echo   访问地址:
echo   - 后台管理: http://localhost:8090/admin/
echo   - 考试系统: http://localhost:8090/
echo ============================================
echo.

pause
