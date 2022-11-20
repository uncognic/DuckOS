del /s /f /q %windir%\temp\*.*
del /s /f /q %windir%\Prefetch\*.*
del /s /f /q %temp%\*.*
rd /s /q %WINDIR%\Logs
del /q %userprofile%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*
del /q %WINDIR%\Downloaded Program Files\*.*
rd /s /q %SYSTEMDRIVE%\$RECYCLE.BIN
if exist "%WINDIR%\DuckOS_Modules\DuckOS-post_script.bat" (
    call "%WINDIR%\DuckOS_Modules\DuckOS-post_script.bat" -CFUExit
)
