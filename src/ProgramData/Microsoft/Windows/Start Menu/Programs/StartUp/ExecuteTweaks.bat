:: Start the post script
start "" "%SystemRoot%\DuckOS_Modules\nsudo.exe" -U:T -P:E "C:\Windows\DuckOS_Modules\DuckOS-post_script.bat" -isDuck

:: Delete this batch file & exit
del /F /Q %0
