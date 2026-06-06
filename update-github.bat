@echo off
chcp 65001 >nul
echo.
echo ╔══════════════════════════════════════════════╗
echo ║   ACTUALITZAR GITHUB — Dashboard Clínic Peu ║
echo ╚══════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

set /p MSG="Descriu el canvi (ex: Update dashboard): "

git add .
git commit -m "%MSG%"
git push

echo.
echo  Publicat! Disponible en 1-2 minuts a:
echo  https://DavidParet.github.io/lesio-peu-dashboard/
echo.
pause
