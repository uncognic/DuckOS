:: Start the post script
start "" "%SystemRoot%\DuckOS_Modules\nsudo.exe" -U:T -P:E "C:\Windows\DuckOS_Modules\DuckOS-post_script.bat"

:: Delete this batch file & exit
del /F /Q %0
exit
