@echo off
title CALIUSO RELOAD API
setlocal enabledelayedexpansion

:: VERIFY VENV EXISTS
if not exist "caliuso-memory-core\venv\Scripts\activate.bat" (
    echo ? ERROR: Virtual environment not found.
    echo Run full deploy script first to set it up.
    timeout /t 5
    exit /b 1
)

:: STEP 1: Kill Port 8000 if needed
echo === CHECKING FOR PORT 8000 ===
for /f "tokens=5" %%a in ('netstat -aon ^| find ":8000" ^| find "LISTENING"') do (
    echo Killing process ID %%a using port 8000...
    taskkill /PID %%a /F
)

:: STEP 2: Activate and Launch
echo === ACTIVATING VENV AND FIRING UVICORN ===
start "" cmd /k "cd caliuso-memory-core && call venv\Scripts\activate.bat && uvicorn caliuso_memory_api:app --host 0.0.0.0 --port 8000"

:: STEP 3: Open Docs
timeout /t 8 >nul
start http://localhost:8000/docs

:: STEP 4: Visual Confirm
echo ? SERVER RELOAD COMPLETE.
timeout /t 5
exit /b 0