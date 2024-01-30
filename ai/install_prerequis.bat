@echo off
set lib=0

ping github.com /w 10000 /n 2 >nul 2>&1 || echo Aucune connexion avec github n'a pu se faire, veuillez reessayer plus tard... && goto end
if not exist privileges.bat powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/cram2000-Kirito/WinBatch/main/privileges.bat -OutFile privileges.bat"
if not exist ai.assistant.py powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/cram2000-Kirito/ai.local/main/ai/ai.assistant.py -OutFile ai.assistant.py"
if not exist ai.launcher.bat powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/cram2000-Kirito/ai.local/main/ai/ai.launcher.bat -OutFile ai.launcher.bat"
call privileges.bat

python --version >nul 2>&1 && goto python_installer
choco --version >nul 2>&1 && goto chocolatey_installer || echo chocolatey n'est pas installe... & goto manual_install_python

:manual_install_python
echo Vous devez donc l'installer manuellement...
timeout 1 >nul
echo La page officiel de python va s'ouvrir sous peux, veuillez cliquer sur le bouton Download Python {version de python}
timeout 2 >nul
echo Une fois le telechargement fini, executer l'installasteur de python et suivez les etapes
timeout 20 >nul
start https://www.python.org/downloads/
timeout 120 >nul
:att
choice /C ON /M "Avez-vous fini d'installer python? " /T 60 /D N
if %ERRORLEVEL%==2 goto :att
start %0
exit

:chocolatey_installer
if defined privileges (if not %privileges%==yes goto end) else goto end
choco install python --y >nul 2>&1 && start %0 & exit
echo Une erreur c'est produite lors de l'installation de python...
goto manual_install_python

:python_installer
if defined privileges (if not %privileges%==yes goto end) else goto end
pip --version >nul 2>&1 && goto pip_installer
echo Une erreur c'est produite lors de l'installation de python...
choco --version >nul 2>&1 || goto manual_uninstall_python
choco uninstall python --y >nul 2>&1 && goto manual_install_python || goto manual_uninstall_python

:manual_uninstall_python
echo Vous devez manuellement deinstaller python
timeout 1 >nul
echo Pour ce faire une fenetre va s'ouvrir sous peut, chercher python par mis cette liste
timeout 2 >nul
echo Double cliquer dessus et suivez les etapes
timeout 120 >nul
:attt
choice /C ON /M "Avez-vous fini de deinstaller python? " /T 60 /D N
if %ERRORLEVEL%==2 goto :attt
goto manual_install_python

:pip_installer
set /a lib=%lib%+1 
pip show openai >nul 2>&1 && goto check_list
pip install openai && goto check_list || echo une erreur c'est produite lors de l'installation de la librairie openai
if lib==1 echo le script va reesayer d'installer la librairie && goto pip_installer
choice /C ON /M "Souhaitez-vous reessayer d'installer la librairie en redemarrant le script? " /T 60 /D O
if %ERRORLEVEL%==2 goto :end
start %0
exit

:check_list
set check="True"
py --version >nul 2>&1 && echo python is installed || echo python n'est pas installe ou mal installe && set check="False"
pip --version >nul 2>&1 && echo pip is installed || echo pip n'est pas installe ou mal installe && set check="False"
pip show >nul 2>&1 && echo lib openai is installed || echo librairie openai est pas ou mal installer && set check="False"
if exist testai.py echo testai.py is exist 
if not exist testai.py echo il manque testai.py && set check="False"
if exist ai.launcher.bat echo ai.launcher.bat is exist
if exist ai.launcher.bat echo il manque ai.launcher.bat && set check="False"
if check=="True" echo Sucessfull !!!
if check=="False" echo veuillez executer &0 pour installer les prerequis & goto end

:end
