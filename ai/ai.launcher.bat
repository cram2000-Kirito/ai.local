@echo off

set "server=192.168.0.21"
if not exist install_prerequis.bat goto end
call install_prerequis.bat check_list
if check=="False" goto end
ping %server% /w 10000 /n 2 >nul 2>&1 || echo Aucune connexion avec l'IA n'a pu se faire... && goto end

py ai.assistant.py

:end