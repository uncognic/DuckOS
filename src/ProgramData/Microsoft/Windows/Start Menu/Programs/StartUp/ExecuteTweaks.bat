
:: Start the post script
cd /d C:\Windows\DuckOS_Modules
taskkill /f /im taskmgr* /t
start "" "%SystemRoot%\DuckOS_Modules\nsudo.exe" -U:T -P:E "C:\Windows\DuckOS_Modules\DuckOS-post_script.bat"

:: delete this batch file
del /F /Q %0
exit