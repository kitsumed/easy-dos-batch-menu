@echo off
rem Verify if the script is running as a elevated process
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script need to run as a elevated process. Please run E-DOS as a administrator.
    exit
)

set scriptMode=Enable
:featureQuestionLoop
cls
echo [Q] Quit the current script
echo [C] Change enable/disable selection
echo.
echo [1] %scriptMode% windows automatic update
echo [2] %scriptMode% including drivers with Windows quality updates (Win10+)
echo [3] %scriptMode% delaying feature updates (not security) for 60 days (Win10+)
echo.
choice /C QC123 /M "Please select a feature."

rem Quit script execution
If %ERRORLEVEL% EQU 1 exit

rem Change enable/disable selection
If %ERRORLEVEL% EQU 2 (
	if "%scriptMode%"=="Enable" (
		set scriptMode=Disable
	) else (
		set scriptMode=Enable
	)
	goto :featureQuestionLoop
)

rem Windows Automatic Update
If %ERRORLEVEL% EQU 3 (
	if "%scriptMode%"=="Enable" (
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /d 0 /t REG_DWORD /f
		reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /f
		reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AutoInstallMinorUpdates /f
		reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoRebootWithLoggedOnUsers /f
	) else (
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /d 1 /t REG_DWORD /f
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /d 2 /t REG_DWORD /f
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AutoInstallMinorUpdates /d 0 /t REG_DWORD /f
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoRebootWithLoggedOnUsers /d 1 /t REG_DWORD /f
	)
	echo [*] Updated windows automatic update.
)

rem Include drivers with Windows quality updates (Win10 and later version only)
If %ERRORLEVEL% EQU 4 (
	if "%scriptMode%"=="Enable" (
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v ExcludeWUDriversInQualityUpdate /d 0 /t REG_DWORD /f
	) else (
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v ExcludeWUDriversInQualityUpdate /d 1 /t REG_DWORD /f
	)
	echo [*] Updated the include setting for drivers in quality updates.
)

rem Defer feature update (not security) (Win10 and later version only)
If %ERRORLEVEL% EQU 5 (
	if "%scriptMode%"=="Enable" (
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DeferFeatureUpdates /d 1 /t REG_DWORD /f
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DeferFeatureUpdatesPeriodInDays /d 60 /t REG_DWORD /f
	) else (
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DeferFeatureUpdates /d 0 /t REG_DWORD /f
		reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DeferFeatureUpdatesPeriodInDays /f
	)
	echo [*] Updated the include setting for drivers in quality updates.
)

pause
goto :featureQuestionLoop