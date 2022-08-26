@echo off && cls && echo ! Loaded.
echo.
echo ! This will RE-INSTALL ALL DuckOS pre-intalled apps below:
echo 1. 7zip
echo 2. OpenShell
echo 3. VCRedists
pause
if exist C:\Windows\Setup\Files\7zip.msi (
	echo ! 7zip installer found.. installing right now..
	start /wait "" "C:\Windows\Setup\Files\7zip.msi" /quiet
	echo ! Done.
)
if exist C:\Windows\Setup\Files\vcredist.exe (
	echo ! VCRedist installer found.. installing right now..
	start /wait "" "C:\Windows\Setup\Files\vcredist.exe" /ai
	echo ! Done.
)
if exist C:\Windows\Setup\Files\openshell.exe (
	echo ! OpenShell installer found.. installing right now..
	start /wait "" "C:\Windows\Setup\Files\openshell.exe" /qn ADDLOCAL=StartMenu
	echo ! Done.
)
exit