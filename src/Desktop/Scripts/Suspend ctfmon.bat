@echo off
cd %windir%
if exist suspend.exe start "" "suspend.exe" ctfmon.exe -nobanner
exit