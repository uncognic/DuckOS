@echo off
cd %windir%
if exist suspend.exe start "" "suspend.exe" winlogon.exe -nobanner
exit