@echo off
chcp 65001 >nul
title Database Reset Tool

set "MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 5.7\bin"
set "DB_NAME=need_to_do"
set "DB_USER=root"
set "DB_PASS=Netsky121666880!"

echo ============================================
echo   Question Database Reset Tool
echo ============================================
echo.
echo   WARNING: This will delete ALL questions and test papers!
echo.
echo   Press any key to continue or Ctrl+C to cancel...
pause >nul

echo.
echo ============================================
echo   Starting database reset...
echo ============================================
echo.

"%MYSQL_PATH%\mysql.exe" -u %DB_USER% -p%DB_PASS% %DB_NAME% -e "source %~dp0reset_questions_database.sql"

if %ERRORLEVEL% equ 0 (
    echo.
    echo ============================================
    echo   SUCCESS!
    echo   All questions and test papers deleted
    echo   IDs reset to 1
    echo ============================================
) else (
    echo.
    echo ============================================
    echo   FAILED!
    echo   Please check if MySQL service is running
    echo ============================================
)

echo.
echo Press any key to exit...
pause >nul
exit
