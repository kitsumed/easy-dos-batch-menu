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
echo [1] %scriptMode% Cortana.
echo [2] %scriptMode% web, cloud and bing search results.
echo [3] %scriptMode% sharing location and search data with bing and Microsoft.
echo [4] %scriptMode% preventing computers remotly connected to host from using search index.
echo.
choice /C QC1234 /M "Please select a option."

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

rem Cortana
If %ERRORLEVEL% EQU 3 (
	if "%scriptMode%"=="Enable" (
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortanaAboveLock /f
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /f
		reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech_OneCore\Preferences /v VoiceActivationDefaultOn /f
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana /v value /d 1 /t REG_DWORD /f
		reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaEnabled /f
		reg delete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaEnabled /f
		reg delete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CanCortanaBeEnabled /f
		reg delete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaConsent /f
		reg delete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v VoiceShortcut /f
		reg delete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowCortanaButton /f
	) else (
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortanaAboveLock /d 0 /t REG_DWORD /f
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /d 0 /t REG_DWORD /f
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech_OneCore\Preferences /v VoiceActivationDefaultOn /d 0 /t REG_DWORD /f
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana /v value /d 0 /t REG_DWORD /f
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaEnabled /d 0 /t REG_DWORD /f
		reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaEnabled /d 0 /t REG_DWORD /f
		reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CanCortanaBeEnabled /d 0 /t REG_DWORD /f
		reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaConsent /d 0 /t REG_DWORD /f
		reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v VoiceShortcut /d 0 /t REG_DWORD /f
		reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowCortanaButton /d 0 /t REG_DWORD /f
	)
	echo [*] Updated Cortana.
)

rem Web, cloud & bing search results
If %ERRORLEVEL% EQU 4 (
	if "%scriptMode%"=="Enable" (
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /f
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /f
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWebOverMeteredConnections /f
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCloudSearch /f
		reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /f
	) else (
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /d 1 /t REG_DWORD /f
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /d 0 /t REG_DWORD /f
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWebOverMeteredConnections /d 0 /t REG_DWORD /f
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCloudSearch /d 0 /t REG_DWORD /f
		reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /d 0 /t REG_DWORD /f
	)
	echo [*] Updated web and bing search options.
)

rem sharing location & search data with bing & Microsoft
If %ERRORLEVEL% EQU 5 (
	if "%scriptMode%"=="Enable" (
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowSearchToUseLocation /f
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchPrivacy /f
	) else (
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowSearchToUseLocation /d 0 /t REG_DWORD /f
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchPrivacy /d 3 /t REG_DWORD /f
	)
	echo [*] Updated location and search data sharing with bing and Microsoft.
)

rem preventing computers remotly connected to host from using search index
If %ERRORLEVEL% EQU 6 (
	if "%scriptMode%"=="Enable" (
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v PreventRemoteQueries /d 1 /t REG_DWORD /f
	) else (
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v PreventRemoteQueries /f
	)
	echo [*] Updated remote queries configuration.
)


pause
goto :featureQuestionLoop