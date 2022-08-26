@echo off && CLS && ! Loaded
echo.
echo ! This script will use chkdsk to check for disk errors. Chkdsk is safe to use and is built in into windows.
pause
echo Y|chkdsk /r
echo Y|chkdsk /f
chkdsk %SystemDrive%
shutdown /a
shutdown /r /t 2
exit