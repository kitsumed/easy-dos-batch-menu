@echo off

:optionQuestionLoop
cls
echo [Q] Quit the current script
echo.
echo [1] Set dark theme
echo [2] Set light theme
echo.
choice /C Q12 /M "Please select a option."

rem Quit script execution
If %ERRORLEVEL% EQU 1 exit

rem Ignore UAC prompt for regedit and run as current user
set __COMPAT_LAYER=RunAsInvoker 
rem Set dark theme
If %ERRORLEVEL% EQU 2 (
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /d 0 /t REG_DWORD /f
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme /d 0 /t REG_DWORD /f
)

rem Set light theme
If %ERRORLEVEL% EQU 3 (
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /d 1 /t REG_DWORD /f
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme /d 1 /t REG_DWORD /f
)

rem Remove UAC skip
set __COMPAT_LAYER= 
echo [*] Done!
pause
goto :optionQuestionLoop