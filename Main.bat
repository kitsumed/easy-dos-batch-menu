@echo off
setlocal enabledelayedexpansion
rem Define the current goto position in the menu for the invalidInput error message
set currentGoto=Home
rem Define the app root directory
set appRootPath=%~dp0
rem Define the winVerNum and winVerName env variables
call "%appRootPath%\get_os_version.bat"
rem [JUMP TO MAIN MENU]
goto Home

rem [INVALID INPUT ERROR]
:invalidInput
cls
echo [^^!] %userChoice% is not a valid choice.
pause
goto :%currentGoto%

rem [MAIN MENU]
:Home
rem Update current goto to come back here when user input is invalid
set currentGoto=Home
rem Reset previous user choice
set userChoice=
title [Home]
cls
echo ==================================
echo ===============Home===============
echo OS : %winVerName% (%winVerNum%)
echo ==================================
echo [0] Exit
echo.
echo [1] List Scripts
echo [2] Open God Mode
echo [3] Open Windows Tools Menu
echo.
echo [4] Open Github Repo
echo.
rem Ask user for a choice
set /P userChoice=Choice : 

if "%userChoice%"=="0" exit
if "%userChoice%"=="1" GOTO scriptsList
if "%userChoice%"=="2" explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C} & goto Home
if "%userChoice%"=="3" explorer.exe shell:::{D20EA4E1-3957-11D2-A40B-0C5020524153} & goto Home
if "%userChoice%"=="4" start https://github.com/kitsumed/easy-dos-batch-menu & goto Home
goto invalidInput

rem [SCRIPTS LIST MENU]
:scriptsList
rem Update current goto to come back here when user input is invalid
set currentGoto=scriptsList
rem Reset previous user choice
set userChoice=
title [Home ^> Scripts List]
cls
echo ==================================
echo ==========Scripts List============
echo OS : %winVerName% (%winVerNum%)
echo ==================================
echo [0] Go Back To Home Menu
echo.
rem Loop trought the scripts folder and show the name of all the directories
for /f %%a in ('dir "%appRootPath%/scripts/" /a:d /b') do (
	set shortDescription=Failed to get short description.
	set /p shortDescription=<"%appRootPath%\scripts\%%a\short.txt"
	rem Print the directory name along with the content of the 'short.txt' file
	echo [%%a] !shortDescription!
)
echo.
rem Verify if the script is running as a elevated process to show a warning if not
net session >nul 2>&1
if %errorlevel% neq 0 echo [*] You are currently running E-DOS as a standard process, some scripts may not function correctly. & echo [*] Write 'elevate' to restart E-DOS with elevated permissions.
rem Ask user for a choice
set /P userChoice=Choice : 
rem Verify if the user choice is empty (prevent trying to get a directory that does not exist)
if "%userChoice%"=="" goto invalidInput

rem Go back to home menu
if "%userChoice%"=="0" GOTO Home

rem Elevate E-DOS with powershell
if "%userChoice%"=="elevate" (
	cls
	net session >nul 2>&1
	if %errorlevel% neq 0 (
		powershell -Command "Start-Process %~f0 -Verb RunAs"
		rem If the errorlevel 0, elevation failed
		if !errorlevel! neq 0 (
			echo [^^!] E-DOS failed to elevate. & pause & goto :scriptsList
		) else exit
	) else echo [^^!] E-DOS is already running as a elevated process. & pause & goto :scriptsList
) 

rem Verify if the selected script directory exist
if exist "%appRootPath%\scripts\%userChoice%\" (
	cls
	title [Home ^> Scripts List ^> %userChoice%]
	echo ==================================
	echo =======Script Information=========
	echo ==================================
	echo Script Name : %userChoice%
	echo Description :
	rem Print the long description of the selected script if a description exist
	if exist "%appRootPath%\scripts\%userChoice%\description.txt" (
		type "%appRootPath%\scripts\%userChoice%\description.txt"
		echo.
	) else (
		echo		There is no detailed description available for this script, falling back to short description.
		echo.
		set /p shortDescription=<"%appRootPath%\scripts\%userChoice%\short.txt"
		echo		%shortDescription%
	)
	echo ==================================
	echo.

	rem Verify if a batch file exist for the current os version (by name) or not
	if exist "%appRootPath%\scripts\%userChoice%\%winVerName%.bat" (
		echo [*] This script has a specific batch file for %winVerName%.
		echo [*] Write 'run' to execute the %winVerName% script. Anything else will take you back to the scripts list.
		rem Ask user for a choice
		set userConfirmation=cancel
		set /P userConfirmation=Confirmation : 

		cls
		if "!userConfirmation!"=="run" cmd /c "%appRootPath%\scripts\%userChoice%\%winVerName%.bat" & echo. & echo [*] Finished running the %winVerName% batch file of this script. & pause
		goto scriptsList
	) else ( 
		echo [^^!] There is no specific batch file for your windows version. ['%winVerName%.bat']
		rem Verify that the script directory has a default batch file (for windows versions without their own batch file)
		if exist "%appRootPath%\scripts\%userChoice%\main.bat" (
			echo [*] A global batch file was found for this script.
			echo [*] Write 'run' to execute the global script. Anything else will take you back to the scripts list.
			rem Ask user for a choice
			set userConfirmation=cancel
			set /P userConfirmation=Confirmation : 

			cls
			if "!userConfirmation!"=="run" cmd /c "%appRootPath%\scripts\%userChoice%\main.bat" & echo. & echo [*] Finished running the global batch file for this script. & pause
			goto scriptsList
		) else (
			echo [^^!] There is no global batch file for this script. ('main.bat')
			echo [^^!] This means this script may only work with certain Windows versions.
			echo.
			pause
			goto scriptsList
		)
	)
) else (
	rem Script directory does not exist, input is invalid
	goto invalidInput
)