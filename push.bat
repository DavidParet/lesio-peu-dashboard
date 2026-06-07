@echo off
cd /d "%~dp0"
git config credential.helper manager
git add .
git commit -m "update" --allow-empty
git push origin main
