@echo off
:: ============================================
:: Register / remove the Scheduled Tasks for membership order maintenance.
:: Must be run as Administrator (right click -> Run as administrator).
::   setup_membership_cron.bat            register
::   setup_membership_cron.bat remove     unregister
::   setup_membership_cron.bat status     show status and last result
:: ============================================

setlocal
set "TASK_SYNC=NeedToDo_MembershipSyncOrders"
set "TASK_CLOSE=NeedToDo_MembershipCloseExpired"
set "CRON_BAT=%~dp0membership_cron.bat"
:: Run interval in minutes
set "SYNC_MINUTES=2"
set "CLOSE_MINUTES=5"

if /i "%~1"=="status" goto status

net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Administrator privileges required. Right click this file and choose "Run as administrator".
    pause
    exit /b 1
)

if /i "%~1"=="remove" goto remove

if not exist "%CRON_BAT%" (
    echo [ERROR] Executable not found: %CRON_BAT%
    pause
    exit /b 1
)

echo [1/3] Register %TASK_SYNC% (every %SYNC_MINUTES% min: fulfil paid pending orders)
schtasks /create /tn "%TASK_SYNC%" /tr "\"%CRON_BAT%\" sync" /sc minute /mo %SYNC_MINUTES% /ru SYSTEM /f

echo [2/3] Register %TASK_CLOSE% (every %CLOSE_MINUTES% min: close unpaid expired orders)
schtasks /create /tn "%TASK_CLOSE%" /tr "\"%CRON_BAT%\" close" /sc minute /mo %CLOSE_MINUTES% /ru SYSTEM /f

echo [3/3] Trigger both once as a smoke test
schtasks /run /tn "%TASK_SYNC%"
schtasks /run /tn "%TASK_CLOSE%"

echo.
echo Done. Check the log in a moment: %~dp0logs\membership_cron.log
exit /b 0

:remove
schtasks /delete /tn "%TASK_SYNC%" /f
schtasks /delete /tn "%TASK_CLOSE%" /f
echo Removed.
exit /b 0

:status
schtasks /query /tn "%TASK_SYNC%" /fo LIST
schtasks /query /tn "%TASK_CLOSE%" /fo LIST
exit /b 0
