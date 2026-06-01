@echo off
setlocal

:: ================================================
:: 数据库同步脚本
:: 支持: 开发环境 <-> 服务端 数据同步
:: ================================================

set INTERNAL_IP=192.168.77.253
set REMOTE_DB=need_to_do
set LOCAL_DB=need_to_do

:menu
cls
echo ================================================
echo         数据库同步工具
echo ================================================
echo.
echo  [1] 从服务器下载数据到本地
echo  [2] 从本地上传数据到服务器
echo  [3] 仅导出表结构(不含数据)
echo  [4] 仅导出题目相关数据
echo  [5] 测试服务器连接
echo  [0] 退出
echo.
echo ================================================
echo.

set /p choice=请选择操作 [1-5, 0退出]:

if "%choice%"=="1" goto download
if "%choice%"=="2" goto upload
if "%choice%"=="3" goto structure
if "%choice%"=="4" goto quiz_data
if "%choice%"=="5" goto test
if "%choice%"=="0" goto end

echo 无效选择，请重新输入！
timeout /t 2 >nul
goto menu

:download
cls
echo ================================================
echo      从服务器下载数据到本地
echo ================================================
echo.
set /p backup_file=请输入备份文件名 [例如: server_backup_%date:~0,4%%date:~5,2%%date:~8,2%]:
if "%backup_file%"=="" set backup_file=server_backup_%date:~0,4%%date:~5,2%%date:~8,2%

echo.
echo [INFO] 正在从服务器导出数据...
mysqldump -h %INTERNAL_IP% -u root -p %REMOTE_DB% > "%backup_file%.sql"

if %errorlevel% equ 0 (
    echo [OK] 导出成功: %backup_file%.sql
    echo.
    set /p confirm=是否导入到本地数据库? (Y/N):
    if /i "%confirm%"=="Y" (
        echo [INFO] 正在导入到本地数据库...
        mysql -u root -p %LOCAL_DB% < "%backup_file%.sql"
        if %errorlevel% equ 0 (
            echo [OK] 导入成功！
        ) else (
            echo [ERROR] 导入失败！
        )
    )
) else (
    echo [ERROR] 导出失败！请检查连接和权限。
)
goto done

:upload
cls
echo ================================================
echo      从本地上传数据到服务器
echo ================================================
echo.
set /p local_file=请输入本地SQL文件路径:
if not exist "%local_file%" (
    echo [ERROR] 文件不存在: %local_file%
    timeout /t 2 >nul
    goto menu
)

echo.
echo [WARNING] 这将覆盖服务器上的数据！
set /p confirm=确认继续? (输入"YES"确认):
if not "%confirm%"=="YES" (
    echo 已取消操作
    timeout /t 2 >nul
    goto menu
)

echo.
echo [INFO] 正在上传数据到服务器...
type "%local_file%" | mysql -h %INTERNAL_IP% -u root -p %REMOTE_DB%

if %errorlevel% equ 0 (
    echo [OK] 上传成功！
) else (
    echo [ERROR] 上传失败！请检查连接和权限。
)
goto done

:structure
cls
echo ================================================
echo      仅导出表结构
echo ================================================
echo.
set /p struct_file=请输入备份文件名 [例如: structure_%date:~0,4%%date:~5,2%%date:~8,2%]:
if "%struct_file%"=="" set struct_file=structure_%date:~0,4%%date:~5,2%%date:~8,2%

echo.
echo [INFO] 正在导出表结构(不含数据)...
mysqldump -h %INTERNAL_IP% -u root -p --no-data %REMOTE_DB% > "%struct_file%.sql"

if %errorlevel% equ 0 (
    echo [OK] 导出成功: %struct_file%.sql
) else (
    echo [ERROR] 导出失败！
)
goto done

:quiz_data
cls
echo ================================================
echo      仅导出题目数据
echo ================================================
echo.
set /p quiz_file=请输入备份文件名 [例如: quiz_data_%date:~0,4%%date:~5,2%%date:~8,2%]:
if "%quiz_file%"=="" set quiz_file=quiz_data_%date:~0,4%%date:~5,2%%date:~8,2%

echo.
echo [INFO] 正在导出quiz应用相关表数据...
mysqldump -h %INTERNAL_IP% -u root -p %REMOTE_DB% quiz > "%quiz_file%.sql"

if %errorlevel% equ 0 (
    echo [OK] 导出成功: %quiz_file%.sql
) else (
    echo [ERROR] 导出失败！
)
goto done

:test
cls
echo ================================================
echo      测试服务器连接
echo ================================================
echo.
echo [INFO] 正在连接服务器MySQL...
mysql -h %INTERNAL_IP% -u root -p -e "SELECT '连接成功!' AS Status; SHOW DATABASES;"

if %errorlevel% equ 0 (
    echo.
    echo [OK] 连接测试成功！
) else (
    echo.
    echo [ERROR] 连接失败！请检查:
    echo   1. VPN是否已连接
    echo   2. 服务器MySQL服务是否运行
    echo   3. 防火墙是否开放3306端口
)
goto done

:done
echo.
pause

:end
echo.
echo ================================================
echo         感谢使用！
echo ================================================
