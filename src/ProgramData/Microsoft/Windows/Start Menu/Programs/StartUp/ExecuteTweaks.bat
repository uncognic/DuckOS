@echo off

:: Set up autologon.
echo Y|reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoAdminLogon" /t REG_DWORD /d "1" /f
echo Y|reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultUserName" /t REG_SZ /d %username% /f
echo Y|reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultPassword" /t REG_SZ /d "" /f

:: Start the post script
cd /d C:\Windows\DuckOS_Modules
taskkill /f /im taskmgr* /t
:: start DuckOS-post_script.bat
start "" "%SystemRoot%\DuckOS_Modules\nsudo.exe" -U:T -P:E "C:\Windows\DuckOS_Modules\DuckOS-post_script.bat"
del /F /Q %0
exit
