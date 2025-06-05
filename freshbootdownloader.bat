@echo off
title CALIUSO FULL DEPLOYMENT ENGINE
setlocal EnableDelayedExpansion

:: =====================
:: STEP 1: Clone Repo
:: =====================
echo [96m=== CLONING MEMORY CORE ===[0m
git clone https://caliuso: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@github.com/caliuso/caliuso-memory-core.git

echo.
if not exist "caliuso-memory-core" (
    echo [91m? CLONE FAILED: Repo folder not found. Check credentials/network![0m
    goto :exitError
)
echo [92m? CLONE SUCCESS: caliuso-memory-core located![0m

:: =====================
:: STEP 2: Setup Python Env
:: =====================
cd caliuso-memory-core

echo [96m=== CREATING VIRTUAL ENV ===[0m
python -m venv venv
if errorlevel 1 goto :exitError

echo [96m=== ACTIVATING VENV ===[0m
call venv\Scripts\activate.bat
if errorlevel 1 goto :exitError

:: =====================
:: STEP 3: Install Requirements
:: =====================
echo [96m=== INSTALLING REQUIREMENTS ===[0m
pip install -r requirements.txt
if errorlevel 1 goto :exitError

:: =====================
:: STEP 4: Kill Existing API Port
:: =====================
echo [96m=== CLEARING PORT 8000 ===[0m
for /f "tokens=5" %%a in ('netstat -aon ^| find ":8000" ^| find "LISTENING"') do (
    echo Killing process ID %%a using port 8000...
    taskkill /PID %%a /F
)

:: =====================
:: STEP 5: Launch Uvicorn
:: =====================
echo [96m=== LAUNCHING UVICORN API ===[0m
start "" cmd /k "cd caliuso-memory-core && call venv\Scripts\activate.bat && uvicorn caliuso_memory_api:app --host 0.0.0.0 --port 8000"

:: =====================
:: STEP 6: Open Docs
:: =====================
timeout /t 8 >nul
start http://localhost:8000/docs

:: =====================
:: SUCCESS
:: =====================
echo.
echo [92m?? DEPLOYMENT COMPLETE. API RUNNING ON PORT 8000![0m
goto :exitClean

:: =====================
:: ERROR HANDLER
:: =====================
:exitError
echo [91m? ERROR DURING DEPLOYMENT. SCRIPT ABORTED![0m
timeout /t 10
exit /b 1

:exitClean
timeout /t 5
exit /b 0