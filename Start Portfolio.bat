@echo off
title First Step Studio Portfolio
cd /d "%~dp0"
echo.
echo   First Step Studio - Portfolio
echo.
echo Starting server...
start "Server" powershell -NoP -Ep Bypass -File "%~dp0server.ps1"
timeout /t 3 /nobreak >nul
start http://localhost:8000
echo.
echo Browser opened at http://localhost:8000
echo Close this window to stop the server.
pause
