del /s /f /q %windir%\temp\*.*
del /s /f /q %windir%\Prefetch\*.*
del /s /f /q %temp%\*.*
rd /s /q %WINDIR%\Logs
del /q %userprofile%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*
del /q %WINDIR%\Downloaded Program Files\*.*
rd /s /q %SYSTEMDRIVE%\$RECYCLE.BIN

:: Credit to privacy.sexy for some of the cleanup
del /f /s /q %appdata%\Listary\UserData
del /f /q %ProgramFiles(x86)%\Steam\Dumps
del /f /q %ProgramFiles(x86)%\Steam\Traces
del /f /q %ProgramFiles(x86)%\Steam\appcache\*.log
rd /s /q "%AppData%\vstelemetry"
rd /s /q "%LocalAppData%\Microsoft\VSApplicationInsights"
rd /s /q "%ProgramData%\Microsoft\VSApplicationInsights"
rd /s /q "%temp%\Microsoft\VSApplicationInsights"
rd /s /q "%temp%\VSFaultInfo"
rd /s /q "%temp%\VSFeedbackPerfWatsonData"
rd /s /q "%temp%\VSFeedbackVSRTCLogs"
rd /s /q "%temp%\VSRemoteControl"
rd /s /q "%temp%\VSTelem"
rd /s /q "%Temp%\VSTelem.Out"
rd /s /q "%AppData%\Sun\Java\Deployment\cache"
rd /s /q "%AppData%\Macromedia\Flash Player"
rd /s /q "%USERPROFILE%\.dotnet\TelemetryStorageService"
reg delete "HKCU\Software\Adobe\MediaBrowser\MRU" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f
reg delete "HKCU\Software\Microsoft\Search Assistant\ACMru" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU" /va /f
reg delete "HKCU\Software\Microsoft\Direct3D\MostRecentApplication" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Direct3D\MostRecentApplication" /va /f
del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\*.db