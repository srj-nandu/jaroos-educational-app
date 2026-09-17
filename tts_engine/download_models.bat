@echo off
title JAROOS Piper Model Downloader
color 0B
echo ================================================================
echo   JAROOS - Piper Voice Model Downloader from Web
echo   Downloads neural ONNX voices into the project folder
echo ================================================================
echo.

cd /d "%~dp0"

echo Available actions:
echo  1. List all models and download status
echo  2. Download en_US-lessac-medium (Mascot & Talking Tom)
echo  3. Download en_US-amy-medium (Teacher & Story Narrator)
echo  4. Download en_US-danny-low (Kid Companion)
echo  5. Download en_US-kathleen-low (Preschool Companion)
echo  6. Download ALL models from Web
echo.
set /p choice="Select an option (1-6) [default 1]: "

if "%choice%"=="" set choice=1
if "%choice%"=="1" python download_models.py --list
if "%choice%"=="2" python download_models.py --model en_US-lessac-medium
if "%choice%"=="3" python download_models.py --model en_US-amy-medium
if "%choice%"=="4" python download_models.py --model en_US-danny-low
if "%choice%"=="5" python download_models.py --model en_US-kathleen-low
if "%choice%"=="6" python download_models.py --all

echo.
pause
