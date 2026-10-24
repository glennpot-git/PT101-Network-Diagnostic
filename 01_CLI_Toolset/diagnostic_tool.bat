@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: PT 101 - PLATFORM TECHNOLOGIES
:: Automation & Diagnostic Script Suite (CLI Toolset)
::
:: QUICK START COMMANDS (cmd):
:: 1. Navigate to tool directory : cd 01_CLI_Toolset
:: 2. Launch diagnostic script  : diagnostic_tool.bat
:: ============================================================================

title Network Diagnostic Workstation - CLI Toolset
color 0F

:: Create logs directory if missing
if not exist "logs" mkdir logs
set "LOGFILE=logs\system_diagnostic_log.txt"

:MENU
cls
echo ============================================================================
echo                 PLATFORM MANAGEMENT AND DIAGNOSTIC TOOLKIT v1.0
echo ============================================================================
echo   [1] Run Network Diagnostics (ipconfig / ping)
echo   [2] Monitor Active System Processes (tasklist)
echo   [3] Log File Management Operations
echo   [4] Run Automated Diagnostic Loop Sequence
echo   [5] Exit Diagnostic Workstation
echo ============================================================================
echo.
set /p "CHOICE=Enter Choice [1-5]: "

if "%CHOICE%"=="1" goto NETWORK_DIAG
if "%CHOICE%"=="2" goto PROCESS_MGMT
if "%CHOICE%"=="3" goto FILE_MGMT
if "%CHOICE%"=="4" goto SCHEDULED_EXEC
if "%CHOICE%"=="5" goto EXIT_TOOL

echo.
echo [!] Invalid selection! Please enter a number between 1 and 5.
timeout /t 2 >nul
goto MENU

:NETWORK_DIAG
cls
echo ============================================================================
echo                            NETWORK DIAGNOSTICS
echo ============================================================================
echo [+] Current Timestamp: %DATE% %TIME%
echo.
echo   [1] Display Network Configuration (ipconfig /all)
echo   [2] Test Host / Gateway Connectivity (ping)
echo   [3] Return to Main Menu
echo.
set /p "NET_CHOICE=Enter Choice [1-3]: "

if "%NET_CHOICE%"=="1" (
    echo.
    echo [+] Running ipconfig /all...
    echo ---------------------------------------------------------------------------- >> "%LOGFILE%"
    echo [LOG ENTRY - %DATE% %TIME%] Running ipconfig /all >> "%LOGFILE%"
    echo ---------------------------------------------------------------------------- >> "%LOGFILE%"
    ipconfig /all
    ipconfig /all >> "%LOGFILE%"
    echo.
    echo [+] Network configuration captured and logged to %LOGFILE%
    echo.
    pause
    goto NETWORK_DIAG
)

if "%NET_CHOICE%"=="2" (
    echo.
    set /p "TARGET=Enter Target Host/IP (Default: google.com): "
    if "!TARGET!"=="" set "TARGET=google.com"
    echo.
    echo [+] Executing connectivity check to !TARGET!...
    echo ---------------------------------------------------------------------------- >> "%LOGFILE%"
    echo [LOG ENTRY - %DATE% %TIME%] Ping test to !TARGET! >> "%LOGFILE%"
    echo ---------------------------------------------------------------------------- >> "%LOGFILE%"
    ping !TARGET! -n 4
    ping !TARGET! -n 4 >> "%LOGFILE%"
    echo.
    echo [+] Ping results saved to %LOGFILE%
    echo.
    pause
    goto NETWORK_DIAG
)

if "%NET_CHOICE%"=="3" goto MENU

echo.
echo [!] Invalid selection!
timeout /t 2 >nul
goto NETWORK_DIAG

:PROCESS_MGMT
cls
echo ============================================================================
echo                      ACTIVE PROCESS MONITORING
echo ============================================================================
echo [+] Capturing system process list (tasklist)...
echo.

echo ---------------------------------------------------------------------------- >> "%LOGFILE%"
echo [LOG ENTRY - %DATE% %TIME%] Task List Snapshot >> "%LOGFILE%"
echo ---------------------------------------------------------------------------- >> "%LOGFILE%"
tasklist
tasklist >> "%LOGFILE%"

echo.
echo [+] Process list captured and recorded to %LOGFILE%
echo.
pause
goto MENU

:FILE_MGMT
cls
echo ============================================================================
echo                         LOG FILE MANAGEMENT
echo ============================================================================
echo Log Directory Contents:
dir logs
echo.
echo   [1] Backup Current Diagnostic Log
echo   [2] Clear Current Diagnostic Log
echo   [3] Return to Main Menu
echo.
set /p "FILE_CHOICE=Enter Choice [1-3]: "

if "%FILE_CHOICE%"=="1" (
    if exist "%LOGFILE%" (
        copy "%LOGFILE%" "logs\backup_diagnostic_log.txt" >nul
        echo [LOG ENTRY - %DATE% %TIME%] Created log backup >> "%LOGFILE%"
        echo.
        echo [+] Log file backed up to logs\backup_diagnostic_log.txt
    ) else (
        echo.
        echo [!] Primary log file does not exist to back up.
    )
    echo.
    pause
    goto FILE_MGMT
)

if "%FILE_CHOICE%"=="2" (
    if exist "%LOGFILE%" (
        del "%LOGFILE%"
        echo.
        echo [+] Primary diagnostic log deleted successfully.
    ) else (
        echo.
        echo [!] No active log file found to delete.
    )
    echo.
    pause
    goto FILE_MGMT
)

if "%FILE_CHOICE%"=="3" goto MENU

echo.
echo [!] Invalid selection!
timeout /t 2 >nul
goto FILE_MGMT

:SCHEDULED_EXEC
cls
echo ============================================================================
echo                     AUTOMATED DIAGNOSTIC SEQUENCE
echo ============================================================================
echo [+] Running diagnostic sequence...
echo [+] Press CTRL+C at any time to interrupt.
echo.

for /L %%I in (1,1,3) do (
    echo [Sequence %%I/3] Timestamp: %DATE% %TIME%
    echo [+] Executing network probe...
    echo [AUTOMATED LOOP %%I - %DATE% %TIME%] >> "%LOGFILE%"
    ping 8.8.8.8 -n 2 >> "%LOGFILE%"
    echo [+] Cycle %%I completed and saved.
    echo ----------------------------------------------------------------------------
    if %%I LSS 3 timeout /t 5
)

echo.
echo [+] Automated diagnostic report sequence complete!
echo.
pause
goto MENU

:EXIT_TOOL
cls
echo ============================================================================
echo [+] Logging exit event...
echo [LOG ENTRY - %DATE% %TIME%] Diagnostic workstation exited. >> "%LOGFILE%"
echo [+] Exiting toolkit...
timeout /t 2 >nul
exit /b 0