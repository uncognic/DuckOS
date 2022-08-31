@echo off

:::::::::::::::::::::::::::::::::::::::::
:: Check for administrative privileges ::
:::::::::::::::::::::::::::::::::::::::::

IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM If there was a error in executing the command, make sure to request administrative privileges
if '%errorlevel%' NEQ '0' (
    echo ---------------------------------------
    echo Requesting administrative privileges...
    echo ---------------------------------------
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

color d
title DuckOS; Connect To WiFi (through command prompt) - Free minitool made for duckOS, by fikinoob
cls
echo ! Generating a list of available networks...
echo ------------------
echo WLAN
echo ------------------
echo.
netsh WLAN show profiles
echo.
echo ------------------
echo LAN
echo ------------------
echo.
echo ! Starting dot3svc service..
net start dot3svc
netsh LAN show profiles
echo * Done.
set /p name=Type the network name you wanna log into:
set /p key=Type the wifi password of the router named %name%:
cls
echo ! Name: %name%
echo ! Key: %key%
echo Attempting connection...
ipconfig /release >nul
ipconfig /renew >nul
netsh wlan set hostednetwork mode=allow ssid="%name%" key="%key%"
echo ! Done.. check if it's connected...
echo Press any key to exit..
pause >nul