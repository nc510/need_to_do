@echo off
chcp 65001 >nul
title Online Exam System - Restart Service

echo ============================================
echo   Online Exam System - Restart Service
echo ============================================
echo.

setlocal enabledelayedexpansion

set "PROJECT_DIR=D:\CODE\Need_To_Do"
set "NGINX_DIR=C:\nginx-1.29.3"
set "BACKEND_PORT=8000"
set "NGINX_PORT=8090"

cd /d "%PROJECT_DIR%"

:: Get timestamp for log file
set "LOG_FILE=%PROJECT_DIR%\logs\restart_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"
set "LOG_FILE=%LOG_FILE: =0%"

:: Create logs directory if not exists
if not exist "%PROJECT_DIR%\logs" mkdir "%PROJECT_DIR%\logs"

:: Redirect all output to log file
call :start_services >> "%LOG_FILE%" 2>&1

:: Exit immediately
exit

:start_services
echo ============================================
echo   Online Exam System - Restart Service
echo ============================================
echo.
echo Started at: %date% %time%
echo.

:: =============================================
:: 1. Stop existing Waitress process (port 8000)
:: =============================================
echo [1/5] Stopping Waitress backend service...
echo   Searching for process listening on port %BACKEND_PORT%...

for /f "tokens=5" %%i in ('netstat -ano ^| findstr ":%BACKEND_PORT%" ^| findstr "LISTENING"') do (
    if not "%%i"=="" (
        echo   Terminating process PID: %%i
        taskkill /f /pid %%i >nul 2>&1
        if !ERRORLEVEL! equ 0 (
            echo   [OK] Process terminated successfully (PID: %%i)
        ) else (
            echo   [WARN] Process %%i may already be stopped
        )
    )
)

echo   Waiting for process to terminate...
timeout /t 2 /nobreak >nul

:: =============================================
:: 2. Reload Nginx configuration
:: =============================================
echo [2/5] Reloading Nginx configuration...

if exist "%NGINX_DIR%\nginx.exe" (
    pushd "%NGINX_DIR%"
    "%NGINX_DIR%\nginx.exe" -s reload >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        echo   [OK] Nginx configuration reloaded
    ) else (
        echo   [INFO] Hot reload failed, trying to restart...
        taskkill /f /im nginx.exe >nul 2>&1
        timeout /t 1 /nobreak >nul
        start "" "%NGINX_DIR%\nginx.exe"
        echo   [OK] Nginx restarted
    )
    popd
) else (
    echo   [ERROR] Nginx not found: %NGINX_DIR%\nginx.exe
)

timeout /t 1 /nobreak >nul

:: =============================================
:: 3. Collect static files (refresh staticfiles)
:: =============================================
echo [3/5] Collecting static files...
python manage.py collectstatic --noinput >nul 2>&1
if !ERRORLEVEL! equ 0 (
    echo   [OK] Static files updated
) else (
    echo   [WARN] Static files collection may have issues
)
timeout /t 1 /nobreak >nul

:: =============================================
:: 4. Start Waitress backend
:: =============================================
echo [4/5] Starting Waitress backend service...

:: Check if already running
netstat -ano | findstr ":%BACKEND_PORT%" | findstr "LISTENING" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    echo   [WARN] Port %BACKEND_PORT% is already in use, skipping start
) else (
    start "" python run.py
    echo   [OK] Waitress start command executed
)

timeout /t 3 /nobreak >nul

:: =============================================
:: 5. Verify service status
:: =============================================
echo [5/5] Verifying service status...
echo.

set "nginx_status=[ERROR] Nginx not started"
set "waitress_status=[ERROR] Waitress not started"
set "admin_status=[ERROR] Admin page not accessible"

:: Check Nginx
netstat -ano | findstr ":%NGINX_PORT%" | findstr "LISTENING" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    set "nginx_status=[OK] Nginx started (port %NGINX_PORT%)"
)

:: Check Waitress
netstat -ano | findstr ":%BACKEND_PORT%" | findstr "LISTENING" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    set "waitress_status=[OK] Waitress started (port %BACKEND_PORT%)"
)

:: Check admin page accessibility
timeout /t 2 /nobreak >nul
for /f %%c in ('curl -s -o NUL -w "%%{http_code}" http://127.0.0.1:%NGINX_PORT%/admin/login/ 2^>nul') do (
    if "%%c"=="200" (
        set "admin_status=[OK] Admin page accessible"
    ) else (
        set "admin_status=[WARN] Admin page returned status: %%c"
    )
)

echo.
echo ============================================
echo   Service Status Report
echo ============================================
echo.
echo   %nginx_status%
echo   %waitress_status%
echo   %admin_status%
echo.

if "!nginx_status:~0,3!"=="[OK]" if "!waitress_status:~0,3!"=="[OK]" (
    echo ============================================
    echo   Service Restart Successful!
    echo.
    echo   Access URLs:
    echo   - Admin: http://localhost:%NGINX_PORT%/admin/
    echo   - Exam System: http://localhost:%NGINX_PORT%/
    echo ============================================
) else (
    echo ============================================
    echo   Services may not be fully started. Check status above.
    echo ============================================
)

echo.
echo Finished at: %date% %time%
exit /b