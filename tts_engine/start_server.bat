@echo off
title JAROOS Piper TTS Neural Server
color 0A
echo ================================================================
echo   JAROOS - Piper TTS Neural Voice Synthesis Engine
echo   Repository: https://github.com/rhasspy/piper
echo ================================================================
echo.

cd /d "%~dp0"

echo [1/3] Checking Python environment...
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [ERROR] Python is not installed or not in system PATH.
    echo Please install Python 3.10+ from https://www.python.org/
    pause
    exit /b 1
)
python --version

echo [2/3] Checking dependencies (piper-tts ^& onnxruntime)...
python -c "import piper; import onnxruntime" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Installing required packages...
    pip install -r requirements.txt
    if %ERRORLEVEL% NEQ 0 (
        color 0C
        echo [ERROR] Failed to install dependencies.
        pause
        exit /b 1
    )
)
echo [OK] Piper and ONNX Runtime are ready.

echo [3/3] Checking port 5002 availability...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5002" ^| findstr "LISTENING"') do (
    echo [INFO] Releasing port 5002 from existing process (PID %%a)...
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo ================================================================
echo   Starting Piper Neural TTS Server on http://localhost:5002
echo   Press Ctrl+C at any time to stop the server.
echo ================================================================
echo.

python server.py --port 5002

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [NOTE] Server terminated with code %ERRORLEVEL%.
    pause
)
