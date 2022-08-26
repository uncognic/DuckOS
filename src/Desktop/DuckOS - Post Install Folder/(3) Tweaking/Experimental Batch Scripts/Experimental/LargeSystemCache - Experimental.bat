@echo off
title LargeSystemCache Tweaking - Experimental
color b
echo.
echo 1. Enable LargeSystemCache
echo 2. Disable LargeSystemCache (Default)
echo.
set /p ans=:
if %ans% EQU 1 goto 1
if %ans% EQU 2 goto 2

:1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f
exit

:2
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "0" /f
exit