@echo off
cd /d "%~dp0"
git add .
git diff --cached --quiet
if %errorlevel% equ 0 (
    echo No hi ha canvis nous.
) else (
    git commit -m "update dashboard"
)
git push origin main
echo.
echo Fet. URL: https://davidparet.github.io/lesio-peu-dashboard/
pause
