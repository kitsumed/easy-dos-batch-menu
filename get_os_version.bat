@echo off
rem Isolate windows version from the "ver" command
rem Detect all Windows versions after XP (xp will fail due to a additional "XP" in the ver string)
for /f "tokens=4 delims=] " %%a in ('ver') do set winVerNum=%%a
set winVerName=Unknown
if %winVerNum% GEQ 10.0.22000 set winVerName=Windows 11
if %winVerNum% GEQ 10.0.10240 if %winVerNum% lss 10.0.22000 set winVerName=Windows 10
rem if %winVerNum% equ 6.3 set winVerName=Windows 8.1
rem if %winVerNum% equ 6.2 set winVerName=Windows 8
rem if %winVerNum% equ 6.1 set winVerName=Windows 7
rem if %winVerNum% equ 6.0 set winVerName=Windows Vista

rem Show a warning if the version wasn't found
if "%winVerName%"=="Unknown" echo [!] WARNING: Failed to detect your Windows version. Your OS might be unsupported. (Version : %winVerNum%) & pause