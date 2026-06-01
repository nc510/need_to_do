@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title 数据库同步工具 - need_to_do

:: 配置参数
set SERVER_HOST=192.168.77.253
set SERVER_PORT=3306
set SERVER_DB=need_to_do
set SERVER_USER=dev_user
set SERVER_PASS=DevPass123456!

set LOCAL_HOST=127.0.0.1
set LOCAL_PORT=3306
set LOCAL_DB=need_to_do_local
set LOCAL_USER=root
set LOCAL_PASS=

set EXPORT_DIR=.\db_backup
set MYSQL_BIN=mysql
set MYSQLDUMP_BIN=mysqldump

:: 创建备份目录
if not exist %EXPORT_DIR% mkdir %EXPORT_DIR%

:menu
cls
echo.
echo ================================================
echo     need_to_do 数据库同步工具
echo ================================================
echo.
echo 服务器配置: %SERVER_HOST%:%SERVER_PORT%/%SERVER_DB%
echo 本地配置:   %LOCAL_HOST%:%LOCAL_PORT%/%LOCAL_DB%
echo.
echo 请选择操作:
echo.
echo [1] 测试服务器连接
echo [2] 测试本地连接
echo [3] 下载服务器数据到本地
echo [4] 上传本地数据到服务器
echo [5] 导出服务器表结构
echo [6] 导出quiz题目数据
echo [7] 退出
echo.
set /p choice=请输入选项 [1-7]: 

if "%choice%"=="1" goto test_server
if "%choice%"=="2" goto test_local
if "%choice%"=="3" goto sync_server_to_local
if "%choice%"=="4" goto sync_local_to_server
if "%choice%"=="5" goto export_schema
if "%choice%"=="6" goto export_quiz_data
if "%choice%"=="7" goto exit

echo 无效选项，请重新选择
pause
goto menu

:test_server
echo.
echo 正在测试服务器连接...
%MYSQL_BIN% -h%SERVER_HOST% -P%SERVER_PORT% -u%SERVER_USER% -p%SERVER_PASS% -e "SELECT VERSION();"
if %errorlevel% equ 0 (
    echo.
    echo ✅ 服务器连接成功!
    %MYSQL_BIN% -h%SERVER_HOST% -P%SERVER_PORT% -u%SERVER_USER% -p%SERVER_PASS% -e "USE %SERVER_DB%; SHOW TABLES;"
) else (
    echo.
    echo ❌ 服务器连接失败!
)
pause
goto menu

:test_local
echo.
echo 正在测试本地连接...
%MYSQL_BIN% -h%LOCAL_HOST% -P%LOCAL_PORT% -u%LOCAL_USER% -p%LOCAL_PASS% -e "SELECT VERSION();"
if %errorlevel% equ 0 (
    echo.
    echo ✅ 本地连接成功!
    %MYSQL_BIN% -h%LOCAL_HOST% -P%LOCAL_PORT% -u%LOCAL_USER% -p%LOCAL_PASS% -e "USE %LOCAL_DB%; SHOW TABLES;" 2>nul || echo 本地数据库 %LOCAL_DB% 不存在
) else (
    echo.
    echo ❌ 本地连接失败!
)
pause
goto menu

:sync_server_to_local
echo.
echo 正在下载服务器数据到本地...
echo 1. 创建本地数据库...
%MYSQL_BIN% -h%LOCAL_HOST% -P%LOCAL_PORT% -u%LOCAL_USER% -p%LOCAL_PASS% -e "CREATE DATABASE IF NOT EXISTS %LOCAL_DB% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

echo 2. 从服务器导出数据...
%MYSQLDUMP_BIN% -h%SERVER_HOST% -P%SERVER_PORT% -u%SERVER_USER% -p%SERVER_PASS% --databases %SERVER_DB% --single-transaction --routines > %EXPORT_DIR%\server_backup.sql

echo 3. 导入到本地数据库...
%MYSQL_BIN% -h%LOCAL_HOST% -P%LOCAL_PORT% -u%LOCAL_USER% -p%LOCAL_PASS% %LOCAL_DB% < %EXPORT_DIR%\server_backup.sql

if %errorlevel% equ 0 (
    echo.
    echo ✅ 数据下载完成! 备份文件: %EXPORT_DIR%\server_backup.sql
) else (
    echo.
    echo ❌ 数据下载失败!
)
pause
goto menu

:sync_local_to_server
echo.
echo ⚠️  警告: 此操作将覆盖服务器数据库!
set /p confirm=请确认是否继续 (y/N): 
if /i not "%confirm%"=="y" (
    echo 操作已取消
    pause
    goto menu
)

echo 正在上传本地数据到服务器...
echo 1. 从本地导出数据...
%MYSQLDUMP_BIN% -h%LOCAL_HOST% -P%LOCAL_PORT% -u%LOCAL_USER% -p%LOCAL_PASS% --databases %LOCAL_DB% --single-transaction --routines > %EXPORT_DIR%\local_backup.sql

echo 2. 导入到服务器...
%MYSQL_BIN% -h%SERVER_HOST% -P%SERVER_PORT% -u%SERVER_USER% -p%SERVER_PASS% %SERVER_DB% < %EXPORT_DIR%\local_backup.sql

if %errorlevel% equ 0 (
    echo.
    echo ✅ 数据上传完成! 备份文件: %EXPORT_DIR%\local_backup.sql
) else (
    echo.
    echo ❌ 数据上传失败!
)
pause
goto menu

:export_schema
echo.
echo 正在导出服务器表结构...
%MYSQLDUMP_BIN% -h%SERVER_HOST% -P%SERVER_PORT% -u%SERVER_USER% -p%SERVER_PASS% --no-data %SERVER_DB% > %EXPORT_DIR%\schema.sql

if %errorlevel% equ 0 (
    echo ✅ 表结构导出完成! 文件: %EXPORT_DIR%\schema.sql
) else (
    echo ❌ 导出失败!
)
pause
goto menu

:export_quiz_data
echo.
echo 正在导出quiz题目数据...
%MYSQLDUMP_BIN% -h%SERVER_HOST% -P%SERVER_PORT% -u%SERVER_USER% -p%SERVER_PASS% %SERVER_DB% quiz_question quiz_testpaper quiz_answerrecord quiz_testrecord --single-transaction > %EXPORT_DIR%\quiz_data.sql

if %errorlevel% equ 0 (
    echo ✅ quiz数据导出完成! 文件: %EXPORT_DIR%\quiz_data.sql
) else (
    echo ❌ 导出失败!
)
pause
goto menu

:exit
echo.
echo 感谢使用!
endlocal
exit /b 0
