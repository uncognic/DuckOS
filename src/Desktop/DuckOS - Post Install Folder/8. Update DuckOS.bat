@echo off
cls
if exist "%WINDIR%\DuckOS_Modules\DuckOS-post_script.bat" ( call "%WINDIR%\DuckOS_Modules\DuckOS-post_script.bat" -CFUExit ) else (
    color cf
    echo THE POST SCRIPT DOESN'T EXIST. WHAT DID YOU DO?
    echo Press any key to exit. . .
    pause >nul
    exit
)