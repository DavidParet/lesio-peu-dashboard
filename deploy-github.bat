@echo off
chcp 65001 >nul
echo.
echo ╔══════════════════════════════════════════════╗
echo ║   PUBLICAR A GITHUB — Dashboard Clínic Peu  ║
echo ╚══════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo [1/5] Inicialitzant repositori Git...
git init
git config user.email "david.paret.garcia@gmail.com"
git config user.name "David Paret"

echo.
echo [2/5] Afegint tots els fitxers...
git add .

echo.
echo [3/5] Fent commit inicial...
git commit -m "Versio inicial: Dashboard Clinic Peu - fascitis plantar"

echo.
echo [4/5] Configurant branca principal i repositori remot...
git branch -M main
git remote remove origin 2>nul
git remote add origin https://github.com/DavidParet/lesio-peu-dashboard.git

echo.
echo [5/5] Pujant a GitHub...
echo (Si demana usuari/contrasenya, usa el teu Personal Access Token de GitHub)
echo.
git push -u origin main

echo.
echo ════════════════════════════════════════════════
echo  Comprova la URL: https://DavidParet.github.io/lesio-peu-dashboard/
echo  (disponible en 1-2 minuts despres d'activar GitHub Pages)
echo ════════════════════════════════════════════════
echo.
pause
