@echo off
cd /d "%~dp0"
taskkill /f /im chrome.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --allow-file-access-from-files "index.html"
echo.
echo Done.
pause
