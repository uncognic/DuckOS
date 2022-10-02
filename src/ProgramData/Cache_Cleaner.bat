del /s /f /q %windir%\temp\*.*
del /s /f /q %windir%\Prefetch\*.*
del /s /f /q %temp%\*.*
del C:\*.log /s /q /f
del C:\*.tmp /s /q /f
del /q %userprofile%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*
del /q C:\Windows\Downloaded Program Files\*.*
rd /s /q %SYSTEMDRIVE%\$RECYCLE.BIN
exit
