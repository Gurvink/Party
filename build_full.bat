@echo off
echo Bouwen van web-app...
call flutter build web

echo Kopieer web build naar assets...
xcopy /E /Y /I build\web\* assets\web\

echo Bouwen van Windows-app...
call flutter build windows

echo Build compleet!
pause