@echo off
:: ============================================
:: Membership order maintenance (executed by Scheduled Tasks, not by hand)
::   membership_cron.bat sync   -> query pending orders, fulfil the paid ones
::   membership_cron.bat close  -> close orders past the payment deadline
::   membership_cron.bat both   -> run both
:: Log: logs\membership_cron.log
:: ============================================

setlocal
set "PROJECT_DIR=%~dp0"
:: Python interpreter. Leave empty to auto-detect (candidate must import django).
set "PYTHON="

cd /d "%PROJECT_DIR%"
if not exist "%PROJECT_DIR%logs" mkdir "%PROJECT_DIR%logs"

if /i "%~1"=="sync"  goto sync
if /i "%~1"=="close" goto close
if /i "%~1"=="both"  goto both
echo Usage: membership_cron.bat [sync^|close^|both]
exit /b 2

:sync
call :run sync_pending_orders
exit /b %ERRORLEVEL%

:close
call :run close_expired_orders
exit /b %ERRORLEVEL%

:both
call :run sync_pending_orders
call :run close_expired_orders
exit /b %ERRORLEVEL%

:run
call :detect_python
if not defined PYTHON (
    echo [%date% %time%] [ERROR] no usable python found >> "%PROJECT_DIR%logs\membership_cron.log"
    exit /b 1
)
echo [%date% %time%] ----- manage.py %~1 ----- >> "%PROJECT_DIR%logs\membership_cron.log"
"%PYTHON%" manage.py %~1 >> "%PROJECT_DIR%logs\membership_cron.log" 2>&1
exit /b %ERRORLEVEL%

:: Pick the first interpreter that can import django.
:detect_python
if defined PYTHON exit /b 0
for %%P in ("C:\ProgramData\miniconda3\python.exe" "C:\ProgramData\miniconda3\envs\need_vv\python.exe" "python") do (
    if not defined PYTHON (
        %%~P -c "import django" >nul 2>&1
        if not errorlevel 1 set "PYTHON=%%~P"
    )
)
exit /b 0
