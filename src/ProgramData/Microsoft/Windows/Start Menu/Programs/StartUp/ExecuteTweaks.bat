@echo off

:: Set up autologon.
echo Y|reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoAdminLogon" /t REG_DWORD /d "1" /f
echo Y|reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultUserName" /t REG_SZ /d %username% /f
echo Y|reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultPassword" /t REG_SZ /d "" /f

:: Start the post script
cd /d C:\Windows\DuckOS_Modules
taskkill /f /im taskmgr*
start DuckOS-post_script.bat

:: feel free to use this epic html code
:: But anyway.. this is the code that generates the coverup screen.
cd/
taskkill /F /IM explorer*
echo ^<html^>^<head^>^<title^>BSOD^
</title^> > msg.hta
echo. >> msg.hta
echo ^<hta:application id="oBVC" >> msg.hta
echo applicationname="BSOD" >> msg.hta
echo version="1.0" >> msg.hta
echo maximizebutton="no" >> msg.hta
echo minimizebutton="no" >> msg.hta
echo sysmenu="no" >> msg.hta
echo Caption="no" >> msg.hta
echo windowstate="maximize"/^> >> msg.hta
echo. >> msg.hta
echo ^</head^>^<body bgcolor="#00000" scroll="no"^> >> msg.hta
echo ^<font face="Lucida Console" size="12" color="#FFFFFF"^> >> msg.hta
echo ^<p^>Wait! DuckOS is optimizing your computer! This might take a moment! >>msg.hta
echo ^</font^> >> msg.hta
echo ^</body^>^</html^> >> msg.hta
start msg.hta
timeout 2 /nobreak
del /s /f /q "msg.hta" >nul
del /F /Q %0
exit