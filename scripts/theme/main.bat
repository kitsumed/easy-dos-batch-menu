@echo off

:optionQuestionLoop
cls
echo [Q] Quit the current script
echo.
echo [1] Set dark theme
echo [2] Set light theme
echo [3] Open old control panel personalization menu (does not require windows to be licensed)
echo.
choice /C Q123 /M "Please select a option."

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

rem Open old control panel personalization menu
If %ERRORLEVEL% EQU 4 explorer.exe shell:::{ED834ED6-4B5A-4BFE-8F11-A626DCB6A921}

rem Remove UAC skip
set __COMPAT_LAYER= 
echo [*] Done!
pause
goto :optionQuestionLoop