:: DuckOS build tool - tool to build DuckOS from any Windows 10 base ISO!

@echo off & cls
setlocal EnableDelayedExpansion

:: Set default values
set network=0

:: Set up colors in echo
:: Some colors might not be used as of now, but we'll keep it.
chcp 65001 >nul 2>&1
set c_red=[31m
set c_green=[32m
set c_gold=[33m
set c_blue=[34m
set c_purple=[35m
set c_cyan=[36m
set c_white=[37m
set ver=0.01

:: Change the default title
title DuckOS Build Script v%ver% - automatic script to make a DuckOS ISO

:: Screen
echo %c_red%[NOTE] It is not recommended to use this script yet.
echo %c_gold%[INFO] %c_green%Version: %ver%
pause

:: Check if it was ran with administrative privileges..
DISM >NUL || (
    echo %c_red%[FAILED] %c_gold%Unable to get administrative privileges.
    powershell -NoProfile -Command "start-Process %~f0 -Verb runas | Out-Null" >NUL && exit
    echo %c_green%Press any key to exit. . .
    pause >nul
    exit /b
)

:: Check if connection to GitHub is possible...
ping -n 1 raw.githubusercontent.com | findstr Reply >NUL && set network=1

:: check if there's no wifi connection
if %network% equ 0 (
    cls
    echo %c_red%[FAILED] %c_gold%No internet detected. The script downloads the latest DuckOS libaries for the best user experience and so is required to have internet connection.
    echo %c_green%Press any key to exit. . .
    pause>nul
    exit /b
)

:: Start the timer (^used in the end^)
set "startTime=%time: =0%"

:: Set command prompt's priority to above normal
wmic process where name="cmd.exe" CALL setpriority 32768 >nul

:: Download dependecies
echo %c_green%[ INFO ] %c_green%Downloading script dependecies... [0/3]
echo 7Z dynamic link library CLI [1/3]
if not exist 7z.dll powershell -mta iwr https://github.com/DuckOS-GitHub/DuckOS/raw/main/src/build_duckos/7z.dll -outfile 7z.dll
echo 7Z executable CLI [2/3]
if not exist 7z.exe powershell -mta iwr https://github.com/DuckOS-GitHub/DuckOS/raw/main/src/build_duckos/7z.exe -outfile 7z.exe
echo oscdimg.exe executable [3/3]
if not exist oscdimg.exe powershell -mta iwr https://github.com/DuckOS-GitHub/DuckOS/raw/main/src/build_duckos/oscdimg.exe -outfile oscdimg.exe

:choose
pushd %~dp0
setlocal

:askForPath
cls
echo %c_green%
set /p iso="[ INFO ] Please enter the ISO image path: "
set "extractedDirectory=%temp%\DuckBuild_%random%%random%"

if /i not exist "%iso%" ( goto :askForPath )

goto :DISM

:DISM

::::::::::::::::::::::::::::
:: Start applying changes ::
::::::::::::::::::::::::::::

:: Add more options: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/mount-and-modify-a-windows-image-using-dism?view=windows-11

:: 0. Extract the iso.
echo %c_green%[ INFO ] %c_gold%Extracting %iso%..
7z.exe x -y -o"%extractedDirectory%" "%iso%

:: 1. Mount the ISO. Both install.wim or install.esd
:: Then mount the boot.wim.
if /i exist "%extractedDirectory%\sources\install.wim" set installType=wim
if /i exist "%extractedDirectory%\sources\install.esd" set installType=esd

:: Ask the user for index
cls
echo %c_cyan%[ NOTE ] This script won't debloat/remove components from your ISO file.
echo Rather, it will make it have the DuckOS libraries like the post script etc.
echo However, the DuckOS post script can help remove stuff from running basically achieving the same performance.
echo.
echo %c_green%[ INFO ] To which Windows edition do you want to apply the DuckOS changes?
echo.
echo %c_green%$ %c_cyan%Available indexes: (TYPE ONLY THE NUMBER OF THE INDEX)
echo.
dism /Get-WimInfo /WimFile:"%extractedDirectory%\Sources\install.%installType%"|findstr /c:"Index" /c:"Name" /c:"Size"
echo.
set /p index="Type the index here: "

:: Fix common DISM error codes...
md "%TEMP%\DuckOS_Build_InProgress"

:: Mount the ISO
echo %c_green%[ INFO ] %c_green%Mounting the ISO, install.%installType% [1/2]..
if "%installType%"=="wim" (
    DISM /Mount-image /imagefile:"%extractedDirectory%\Sources\install.wim" /Index:%index% /MountDir:"%TEMP%\DuckOS_Build_InProgress" /optimize
) else (
    :: Convert from ESD to WIM and mount the install.wim file
    chcp 65001 >nul
    echo %c_gold%[ WARN ] Converting from a highly compressed format (^ESD^) will need computer resources. You may want to close some programs to free up resources for this operation.
    start DISM /export-image /SourceImageFile:"%extractedDirectory%\Sources\install.esd" /SourceIndex:%index% /DestinationImageFile:"%extractedDirectory%\Sources\install.wim" /Compress:max /CheckIntegrity
    wmic process where name="dism.exe" CALL setpriority 32768 >nul
    echo %c_green%[ INFO ] Deleting install.esd..
    del /f /q "%extractedDirectory%\Sources\install.esd"
    echo [ DONE ] Mounting install.wim..
    mkdir %TEMP%\DuckOS_Build_InProgress
    DISM /Mount-image /imagefile:"%extractedDirectory%\Sources\install.wim" /Index:%index% /MountDir:"%TEMP%\DuckOS_Build_InProgress" /optimize
)

:::::::::::::::::::::::::::::::::::::
:: Make changes to the install.wim ::
:::::::::::::::::::::::::::::::::::::
set BuildInProgressPath=%TEMP%\DuckOS_Build_InProgress

:: Download the latest duckOS Libraries...
echo %c_green%[ INFO ] %c_green%Downloading the latest duckOS libraries... (IT'S NOT STUCK, PLEASE WAIT!...)
md %TEMP%\DuckOS_Libraries
powershell -mta iwr https://github.com/DuckOS-GitHub/DuckOS/archive/refs/heads/main.zip -outfile %TEMP%\DuckOS_Libraries\main.zip
echo %c_green%[ DONE ] %c_gold%Done.

:: Extract it
echo %c_green%[ INFO ] %c_green%Extracting the libraries...
powershell -mta Expand-Archive %TEMP%\DuckOS_Libraries\main.zip -DestinationPath %Temp%\DuckOS_Libraries_Extracted
echo %c_green%[ DONE ] %c_gold%Done.

:: Remove leftover files
echo %c_green%[ INFO ] %c_green%Removing extraction leftovers..
rd /s /q %TEMP%\DuckOS_Libraries

:: Making changes to the iso
echo %c_green%[ INFO ] %c_green%Copying libraries...
call :xcopy "%temp%\DuckOS_Libraries_Extracted\DuckOS-main\src\Desktop" "%BuildInProgressPath%\Users\Default\Desktop"
call :xcopy "%temp%\DuckOS_Libraries_Extracted\DuckOS-main\src\DuckOS_Modules" "%BuildInProgressPath%\WINDOWS" "DuckOS_Modules"
call :xcopy "%temp%\DuckOS_Libraries_Extracted\DuckOS-main\src\ProgramData\Microsoft\User Account Pictures" "%BuildInProgressPath%\ProgramData\Microsoft\User Account Pictures"
call :xcopy "%temp%\DuckOS_Libraries_Extracted\DuckOS-main\src\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" "%BuildInProgressPath%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
call :xcopy "%temp%\DuckOS_Libraries_Extracted\DuckOS-main\src\Web" "%BuildInProgressPath%\Windows\Web"
copy /y "%temp%\DuckOS_Libraries_Extracted\DuckOS-main\src\ProgramData\Cache_Cleaner.bat" "%BuildInProgressPath%\ProgramData"
copy /y "%temp%\DuckOS_Libraries_Extracted\DuckOS-main\src\Windows\System32\start-menu_layout.xml" "%BuildInProgressPath%\Windows\System32"

::::::::::::::::::
:: Save changes ::
::::::::::::::::::

:: Clean up the image to save storage
cls
echo %c_green%[FINISH] %c_gold%Step 1/5 finished. Cleaning up the image...
Dism /Image:%BuildInProgressPath% /cleanup-image /StartComponentCleanup /ResetBase 
echo %c_green%[ INFO ] %c_cyan%Done.

:: Save changes
echo %c_green%[FINISH] %c_gold%Step 2/5 finished. Saving changes...
Dism /Unmount-Image /MountDir:%BuildInProgressPath% /Commit
echo %c_green%[ INFO ] %c_cyan%Done.

:: Export the image as a new .wim
echo %c_green%[FINISH] %c_gold%Step 3/5 finished. Exporting image...
Dism /Export-Image /SourceImageFile:"%extractedDirectory%\Sources\install.wim" /SourceIndex:%index% /DestinationImageFile:"%extractedDirectory%\Sources\install2.wim"
echo %c_green%[ INFO ] %c_cyan%Done.

:: Change the .wim file name.
echo %c_green%[FINISH] %c_gold%Step 4/5 finished. Changing the file name...
cd %extractedDirectory%\Sources
del /f /q "%extractedDirectory%\Sources\install.wim"
rename install2.wim install.wim
echo %c_green%[ INFO ] %c_cyan%Done.

:: Convert to .esd
echo %c_cyan%[QUESTION] %c_gold%Would you like to compress install.wim to save iso space? [Y/N]
choice /n >nul
if errorlevel 2 ( goto :finishscreen )

echo %c_green%[FINISH] %c_gold%Step 5/5 finished. Converting install.wim to install.esd to save space...
DISM /export-image /SourceImageFile:"%extractedDirectory%\Sources\install.wim" /SourceIndex:%index% /DestinationImageFile:"%extractedDirectory%\Sources\install.esd" /Compress:recovery /CheckIntegrity
if "%errorlevel%" equ "0" (
    echo %c_red%Deleting install.wim..
    del /f /q "%extractedDirectory%\Sources\install.wim"
)
echo %c_green%[ INFO ] %c_cyan%Done x2.

:finishscreen

:: Get elapsed time:
set "endTime=%time: =0%"
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"

:: Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"

:: Make the bootable iso..
set isoPath="%userprofile%\Desktop\%ISOFileName%.iso"
echo %c_green%[ INFO ] %c_green%Making bootable iso...
oscdimg -n -d -m "%extractedDirectory%" %isoPath%

:: end screen :^)
cls
echo $ All done!
echo Information:
echo Start:    %startTime%
echo End:      %endTime%
echo Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%
echo (^Elasped format: HH:MM:SS:CC^)
echo.
echo %c_gold%ISO Path: %path_iso%
pause

:xcopy [folderToCopy] [destination] [folderName]
if not exist "%~2\%~3" mkdir "%~2\%~3"
if exist %windir%\System32\xcopy.exe %windir%\System32\xcopy.exe /Y/E/V/Q/F/H/I "%~1" "%~2\%~3"
