@echo off
cd %windir%
if exist suspend.exe start "" "suspend.exe" -r winlogon.exe -nobanner
exit