@echo off

net session 1>NUL 2>NUL || (echo This script requires elevated rights. & exit /b 1)

echo.
echo my-env setup script
echo.

echo - windows terminal symlink...
call :create-link "%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" %CD%\wt.json

echo - powershell profile symlink...
md %USERPROFILE%\Documents\PowerShell > NUL
call :create-link "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" %CD%\pwsh-profile.ps1
echo.

rem used by PowerShell profile script to load Oh My Posh and find my toolbox later.
setx MY_ENV %CD%
setx MY_TOOLBOX %CD%\..\toolbox

echo - installing PowerShell...
winget install Microsoft.PowerShell

goto :EOF

:create-link
del %1
mklink %1 %2
echo.
