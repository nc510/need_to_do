@echo off
setlocal

:: ================================================
:: MySQL内网配置脚本
:: 用于Windows MySQL 5.7
:: ================================================

echo ================================================
echo      MySQL 内网IP绑定配置
echo ================================================
echo.

set MYSQL_INI=C:\ProgramData\MySQL\MySQL Server 5.7\my.ini
set INTERNAL_IP=192.168.77.253
set MYSQL_SERVICE=MySQL57

:: 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 请右键选择"以管理员身份运行"此脚本！
    pause
    exit /b 1
)

:: 备份原配置文件
echo [INFO] 备份原配置文件...
if exist "%MYSQL_INI%" (
    copy /Y "%MYSQL_INI%" "%MYSQL_INI%.backup_%date:~0,4%%date:~5,2%%date:~8,2%" >nul
    echo [OK] 备份完成
) else (
    echo [ERROR] 找不到MySQL配置文件: %MYSQL_INI%
    echo 请确认MySQL安装路径
    pause
    exit /b 1
)

echo.
echo [INFO] 修改MySQL配置...
echo.

:: 使用PowerShell修改ini文件
powershell -Command ^
"$content = Get-Content '%MYSQL_INI%' -Raw; " ^
"$content = $content -replace 'bind-address\s*=\s*127\.0\.0\.1', 'bind-address=%INTERNAL_IP%'; " ^
"$content = $content -replace 'bind-address\s*=\s*0\.0\.0\.0', 'bind-address=%INTERNAL_IP%'; " ^
"$content = $content -replace 'bind-address\s*=\s*\d+\.\d+\.\d+\.\d+', 'bind-address=%INTERNAL_IP%'; " ^
"if (-not ($content -match 'bind-address')) { " ^
"    $content = $content -replace '(\[mysqld\])', ('$1' + [Environment]::NewLine + 'bind-address=%INTERNAL_IP%'); " ^
"} " ^
"Set-Content -Path '%MYSQL_INI%' -Value $content -NoNewline; " ^
"Write-Host '[OK] 配置已更新'; "

if %errorlevel% neq 0 (
    echo [ERROR] 配置修改失败
    pause
    exit /b 1
)

echo.
echo [INFO] 重启MySQL服务...

:: 停止MySQL服务
net stop %MYSQL_SERVICE%
if %errorlevel% neq 0 (
    echo [WARN] 停止服务失败，尝试强制停止...
    sc queryex %MYSQL_SERVICE% | findstr PID
    set /p PID=请输入PID并手动结束进程，然后按任意键继续...
)

:: 等待几秒
timeout /t 3 /nobreak >nul

:: 启动MySQL服务
net start %MYSQL_SERVICE%
if %errorlevel% neq 0 (
    echo [ERROR] MySQL服务启动失败
    echo 请检查事件查看器或手动启动服务
    pause
    exit /b 1
)

echo.
echo ================================================
echo      配置完成！
echo ================================================
echo.
echo 内网访问信息:
echo   IP:   %INTERNAL_IP%
echo   端口: 3306
echo.
echo 本地连接测试:
echo   mysql -h %INTERNAL_IP% -u dev_user -p
echo.
pause
