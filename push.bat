@echo off
cd /d "%~dp0"
git add .
git commit -m "fix data loading and cache" --allow-empty
git push origin main
pause
