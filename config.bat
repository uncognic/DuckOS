:: DuckOS Post Install Script.
:: made by fikinoob#0001

@echo off
SETLOCAL EnableDelayedExpansion

:: Create log directory, for troubleshooting
mkdir C:\Windows\DuckModules\logs
setx path "%path%;C:\Windows\DuckModules;" -m  >nul 2>nul

:: Set enviroment variables
for /f "tokens=2 delims==" %%a in ('wmic os get TotalVisibleMemorySize /format:value ^| findstr "TotalVisibleMemorySize"') do set "TotalVisibleMemorySize=%%a"
set /a RAM=%TotalVisibleMemorySize%+1024000

for /f "delims=:{}" %%i in ('wmic path Win32_systemenclosure get ChassisTypes^| findstr [0-9]') do set "CHASSIS=%%i"
set /a LAPTOP=0
if %CHASSIS% GTR 7 ( 
if %CHASSIS% LSS 17 ( set /a LAPTOP=1 )
if %CHASSIS% GTR 28 ( set /a LAPTOP=1 ) 
)

:: Start Atlas Tweaks too
cd C:\Windows\DuckModules
for %%i in (C:\Windows\DuckModules\*.reg) do reg import %%i

echo ! Please dont close anything. 

:: change ntp server from windows server to pool.ntp.org
sc config W32Time start=demand >nul 2>nul
sc start W32Time >nul 2>nul
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
sc queryex "w32time"|Find "STATE"|Find /v "RUNNING"||(
    net stop w32time
    net start w32time
) >nul 2>nul

:: resync time to pool.ntp.org
w32tm /config /update
w32tm /resync
sc stop W32Time
sc config W32Time start=disabled

:: RUN CACHE CLEANER ON STARTUP
schtasks /create /f /sc ONLOGON /ru "nt authority\system" /tn "\DuckOS Cache Cleaner" /tr "\"%ProgramData%\cache-cleaner.bat\"" /delay 0000:30 >nul 2>&1

:: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/language-packs-known-issue
schtasks /Change /Disable /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" >nul 2>nul
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Control Panel\International" /v "BlockCleanupOfUnusedPreinstalledLangPacks" /t REG_DWORD /d "1" /f

:: Disable unneeded Tasks
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineCore" >nul 2>nul
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineUA" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Autochk\Proxy" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" >nul 2>nul
:: Breaks setting Lock Screen
:: schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\CreateObjectTask"
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" >nul 2>nul
:: Should already be disabled
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Report policies" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Work" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UPnP\UPnPHostConfig" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdates" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\SmartRetry" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Printing\EduPrintProv" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Ras\MobilityManager" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\PushToInstall\LoginCheck" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Diagnosis\Scheduled" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Wininet\CacheTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Setup\Metadata Refresh" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" >nul 2>nul
cls
echo Please wait. This may take a moment.

:: Delete Adobe Font Type Manager
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f

:: Disable USB Autorun/play
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f

:: Disable Camera Access when locked
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f

:: Disable Remote Assistance
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Remote Assistance" /v "fEnableChatControl" /t REG_DWORD /d "0" /f

:: Mitigate against HiveNightmare/SeriousSAM
icacls %windir%\system32\config\*.* /inheritance:e

:: Set strong cryptography on 64 bit and 32 bit .Net Framework (version 4 and above) to fix a Scoop installation issue
:: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f

:: Disable Network Navigation pane in file explorer
reg add "HKEY_CLASSES_ROOT\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2962489444 /f



:: Import the powerplan
powercfg -import "C:\Windows\DuckModules\Duck.pow" 11111111-1111-1111-1111-111111111111
powercfg /s 11111111-1111-1111-1111-111111111111

:: tokens arg breaks path to just \Device instead of \Device Parameters
:: Disable Power savings on drives
for /f "tokens=*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f
powershell -NoProfile -Command "$devices = Get-WmiObject Win32_PnPEntity; $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($p in $powerMgmt){$IN = $p.InstanceName.ToUpper(); foreach ($h in $devices){$PNPDI = $h.PNPDeviceID; if ($IN -like \"*$PNPDI*\"){$p.enable = $False; $p.psbase.put()}}}" >nul 2>nul

:: Make certain applications in the DuckModules folder request UAC
:: Although these applications may already request UAC, setting this compatibility flag ensures they are ran as administrator
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\DuckModules\serviwin.exe" /t REG_SZ /d "~ RUNASADMIN" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\DuckModules\DevManView.exe" /t REG_SZ /d "~ RUNASADMIN" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\DuckModules\nsudo.exe.exe" /t REG_SZ /d "~ RUNASADMIN" /f


cls
echo Please wait. This may take a moment.

:: Unhide powerplan attributes
:: Credits to: Eugene Muzychenko
for /f "tokens=1-9* delims=\ " %%A in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings /s /f attributes /e') do (
  if /i "%%A" == "HKEY_LOCAL_MACHINE" (
    set Ident=
    if not "%%G" == "" (
      set Err=
      set Group=%%G
      set Setting=%%H
      if "!Group:~35,1!" == "" set Err=group
      if not "!Group:~36,1!" == "" set Err=group
      if not "!Setting!" == "" (
        if "!Setting:~35,1!" == "" set Err=setting
        if not "!Setting:~36,1!" == "" set Err=setting
        Set Ident=!Group!:!Setting!
      ) else (
        Set Ident=!Group!
      )
      if not "!Err!" == "" (
        echo ***** Error in !Err! GUID: !Ident"
      )
    )
  ) else if "%%A" == "Attributes" (
    if "!Ident!" == "" (
      echo ***** No group/setting GUIDs before Attributes value
    )
    set /a Attr = %%C
    set /a Hidden = !Attr! ^& 1
    if !Hidden! equ 1 (
      echo Unhiding !Ident!
      powercfg -attributes !Ident::= ! -attrib_hide
    )
  )
)

:: Residual File Cleanup
:: Files are removed in official ISO
del /F /Q "%WinDir%\System32\GameBarPresenceWriter.exe" >nul 2>nul
del /F /Q "%WinDir%\System32\mobsync.exe" >nul 2>nul
del /F /Q "%WinDir%\System32\mcupdate_genuineintel.dll" >nul 2>nul
del /F /Q "%WinDir%\System32\mcupdate_authenticamd.dll" >nul 2>nul
:: Remove Edge
rmdir /s /q "C:\Program Files (x86)\Microsoft" >nul 2>nul
:: Remove residual registry keys
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\Classes\MSEdgeHTM" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\EventLog\Application\edgeupdate" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\EventLog\Application\edgeupdatem" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Clients\StartMenuInternet\Microsoft Edge" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\EdgeUpdate" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Edge" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\Clients\StartMenuInternet\Microsoft Edge" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Device Metadata" /f >nul 2>nul

:: go away

reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f

:: network stuff go away

netsh int tcp set heuristics disabled
netsh int tcp set supplemental Internet congestionprovider=ctcp
netsh int tcp set global timestamps=disabled
netsh int tcp set global rsc=disabled
for /f "tokens=1" %%i in ('netsh int ip show interfaces ^| findstr [0-9]') do (
	netsh int ip set interface %%i routerdiscovery=disabled store=persistent
)

:: Windows Server Update Client ID
sc stop wuauserv >nul 2>nul
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v "SusClientId" /t REG_SZ /d "00000000-0000-0000-0000-000000000000" /f

:: disable hibernation
powercfg -h off

:: Disable Network Adapters
:: IPv6, Client for Microsoft Networks, QoS Packet Scheduler, File and Printer Sharing
powershell -NoProfile -Command "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_pacer, ms_server" >nul 2>&1

:: Disable Devices
devmanview /disable "Composite Bus Enumerator"

:: Drivers

reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\3ware" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\ADP80XX" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\AmdK8" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\arcsas" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\AsyncMac" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\bindflt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\buttonconverter" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\CAD" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\cdfs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\CimFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\circlass" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\cnghwassist" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\CompositeBus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dfsc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\ErrDev" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\fdc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\flpydisk" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\fvevol" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\nvraid" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\QWAVEdrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\rdyboost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\srv2" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\sfloppy" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SiSRaid2" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SiSRaid4" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip6" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\tcpipreg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Telemetry" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\udfs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\umbus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\VerifierExt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\vsmraid" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\VSTXRAID" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\wcnfs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\WindowsTrustedRTProxy" /v "Start" /t REG_DWORD /d "4" /f

:: Remove SOME dependencies
:: GO AWAY
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\rdyboost" /v "DependOnService" /t REG_MULTI_SZ /d "" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ  /d "" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ  /d "" /f



:: Registry
:: Done through script now, HKCU\.. keys often don't integrate correctly.


:: BSOD QoL
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f

:: GPO for Startmenu (tiles)
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "C:\Windows\layout.xml" /f

:: Enable dark mode, disable transparency
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f

:: Disable Windows Updates
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AllowAutoWindowsUpdateDownloadOverMeteredNetwork" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableDualScan" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AUPowerManagement" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationDisable" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuilds" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuildsPolicyValue" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdates" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "BranchReadinessLevel" /t REG_DWORD /d "20" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdatesPeriodInDays" /t REG_DWORD /d "365" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUAsDefaultShutdownOption" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUShutdownOption" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "EnableFeaturedSoftware" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "	DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f


:: Disable Speech Model Updates
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f

::Disable Windows Insider and Build Previews
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f


::  Maps Updates/Downloads
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f

:: Disable CEIP
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f

:: Disable Windows Media Player DRM Online Access
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f

:: Disable Web in Search
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f


:: Data Queue Sizes
:: Go away!
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "25" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "25" /f


:: Explorer
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f
:: Old Alt Tab
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f


:: Application Compatability
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f


:: Disable Mouse Acceleration
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f




:: Disable Annoying Keyboard Features
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f

:: Disable Connection Checking (pings Microsoft Servers)
:: May cause internet icon to show it is disconnected
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t REG_DWORD /d "0" /f

:: Restrict Windows' access to internet resources
:: Enables various other GPOs that limit access on specific windows services
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InternetManagement" /v "RestrictCommunication" /t REG_DWORD /d "1" /f

:: Disable Text/Ink/Handwriting Telemetry
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f


:: Disable Windows Error Reporting
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f


:: Disable Data Collection
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f

:: Misc
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f

:: Content Delivery Manager
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314563Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f

:: Advertising Info
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f


:: Disable Sleep Study
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f


:: Opt-out of sending KMS client activation data to Microsoft automatically. Enabling this setting prevents this computer from sending data to Microsoft regarding its activation state.
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f


:: Disable Feedback
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f

:: Disable Settings Sync
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f


:: Power
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f


:: Location Tracking
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f


:: remove readyboost tab
reg delete "HKEY_CLASSES_ROOT\Drive\shellex\PropertySheetHandlers\{55B3A0BD-4D28-42fe-8CFB-FA3EDFF969B8}" /f >nul 2>nul



:: Hide "Meet Now" button. For future proofing
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f

:: Disable Shared Experiences
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f

:: Internet Explorer QoL
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Main" /v "NoUpdateCheck" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Main" /v "Enable Browser Extensions" /t REG_SZ /d "no" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Main" /v "Isolation" /t REG_SZ /d "PMEM" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer" /v "DisableFlashInIE" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableFixSecuritySettings" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "EnableInPrivateBrowsing" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Main" /v "EnableAutoUpgrade" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Main" /v "HideNewEdgeButton" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Feed Discovery" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Feeds" /v "BackgroundSyncStatus" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\FlipAhead" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing" /v "NewTabPageShow" /t REG_DWORD /d "1" /f

:: show all tasks on control panel, credits to tenforums
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "InfoTip" /t REG_SZ /d "View list of all Control Panel tasks" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "System.ControlPanel.Category" /t REG_SZ /d "5" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\imageres.dll,-27" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\Shell\Open\Command" /ve /t REG_SZ /d "explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f


:: Memory Management
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f


:: Disable Fault Tolerant Heap
:: https://docs.microsoft.com/en-us/windows/win32/win7appqual/fault-tolerant-heap
:: Doc listed as only affected in windows 7, is also in 7+
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f


:: Find correct mitigation values for different windows versions - AMIT
:: initialize bit mask in registry by disabling a random mitigation
powershell -NoProfile -Command Set-ProcessMitigation -System -Disable CFG

reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "%mitigation_mask%" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "%mitigation_mask%" /f

:: https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f

:: MMCSS
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "10000" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "NoLazyMode" /t REG_DWORD /d "1" /f

:: GameBar/FSE
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f

:: Disallow Background Apps
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f

:: Set Win32PrioritySeparation 26 hex/38 dec
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f

:: Disable Notification/Action Center
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f

:: Hung Apps, Wait to Kill, QoL
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9A12038010000000" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f

:: Visual
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f

:: DWM
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f
:: Needs testing
:: https://djdallmann.github.io/GamingPCSetup/CONTENT/RESEARCH/FINDINGS/registrykeys_dwm.txt
:: add batch to new file menu
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f

:: add reg to new file menu
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f

:: Disable Storage Sense
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\StorageSense" /v "AllowStorageSenseGlobal" /t REG_DWORD /d "0" /f

:: Disable Maintenance
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f

:: Do not reduce sounds while in a call
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f

:: Edge
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d "0" /f

:: install cab context menu
reg delete "HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs" /f >nul 2>nul
reg add "HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f
reg add "HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f
reg add "HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k dism /online /add-package /packagepath:\"%%1\"" /f

:: "Merge as TrustedInstaller" for .regs
reg add "HKEY_CLASSES_ROOT\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As TrustedInstaller" /f
reg add "HKEY_CLASSES_ROOT\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f
reg add "HKEY_CLASSES_ROOT\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "nsudo -U:T -P:E reg import "%%1"" /f

:: add run with priority context menu
reg add "HKEY_CLASSES_ROOT\exefile\shell\Priority" /v "MUIVerb" /t REG_SZ /d "Run with priority" /f
reg add "HKEY_CLASSES_ROOT\exefile\shell\Priority" /v "SubCommands" /t REG_SZ /d "" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\001flyout" /ve /t REG_SZ /d "Realtime" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\001flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Realtime \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\002flyout" /ve /t REG_SZ /d "High" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\002flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /High \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\003flyout" /ve /t REG_SZ /d "Above normal" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\003flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /AboveNormal \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\004flyout" /ve /t REG_SZ /d "Normal" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\004flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Normal \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\005flyout" /ve /t REG_SZ /d "Below normal" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\005flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /BelowNormal \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\006flyout" /ve /t REG_SZ /d "Low" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\006flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Low \"%%1\"" /f

:: remove include in library context menu
reg delete "HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>nul

:: Remove Share in context menu
reg delete "HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\ModernSharing" /f >nul 2>nul

:: double click to import power plans
reg add "HKEY_LOCAL_MACHINE\Software\Classes\powerplan\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\powercpl.dll,1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\powerplan\Shell\open\command" /ve /t REG_SZ /d "powercfg /import \"%%1\"" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.pow" /ve /t REG_SZ /d "powerplan" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.pow" /v "FriendlyTypeName" /t REG_SZ /d "PowerPlan" /f

:: set CSRSS to high
:: csrss is responsible for mouse input, setting to high may yield an improvement in input latency.
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f

cd %windows%\DuckModules
powershell -NoProfile -EP Bypass .\devices.ps1 

:::::::::::::::::::::::::
::Storage Optimizations::
:::::::::::::::::::::::::

:: Storage System
fsutil behavior set memoryusage 2 >NUL 2>&1
fsutil behavior set mftzone 2 >NUL 2>&1
fsutil behavior set allowextchar 0 >NUL 2>&1
fsutil behavior set Bugcheckoncorrupt 0 >NUL 2>&1
fsutil behavior set disable8dot3 1 >NUL 2>&1
fsutil behavior set disablecompression 1 >NUL 2>&1
fsutil behavior set disabledeletenotify 0 >NUL 2>&1
fsutil behavior set disableencryption 1 >NUL 2>&1
fsutil behavior set disablelastaccess 1 >NUL 2>&1
fsutil behavior set encryptpagingfile 0 >NUL 2>&1


::::::::::::::::::::::::::
:: Memory Optimizations ::
::::::::::::::::::::::::::


:: Memory Management
reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBoottrace" /t reg_DWORD /d "0" /f >NUL 2>&1


:: SvcSplitThreshold
reg add "HKLM\System\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t reg_DWORD /d "%ram%" /f >NUL 2>&1

:: Large System Cache
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t reg_DWORD /d "1" /f >NUL 2>&1

:: Startup
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_DWORD /d "0" /f >NUL 2>&1

:::::::::::::::::
:: Mitigations ::
:::::::::::::::::

:: Disable DmaRemapping
for /f %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services" /s /f DmaRemappingCompatible ^| find /i "Services\" ') do (
	reg add "%%i" /v "DmaRemappingCompatible" /t reg_DWORD /d "0" /f >NUL 2>&1
)


::CSRSS mitigations
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationAuditOptions /t reg_BINARY /d "222222222222222222222222222222222222222222222222" /f >NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationOptions /t reg_BINARY /d "222222222222222222222222222222222222222222222222" /f >NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v CpuPriorityClass /t reg_DWORD /d "3" /f >NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v IoPriority /t reg_DWORD /d "3" /f >NUL 2>&1


:: Set System Processes Priority below normal
for %%i in (lsass.exe sppsvc.exe SearchIndexer.exe fontdrvhost.exe sihost.exe ctfmon.exe) do (
  reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f
)


:: Set background apps priority below normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe) do (
  reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f
)



:: Disable FTH
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\FTH" /v "Enabled" /t reg_DWORD /d "0" /f >NUL 2>&1

:: Disable Chain Validation
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t reg_DWORD /d "1" /f >NUL 2>&1

:: Correct Mitigation Values
powershell -NoProfile -Command Set-ProcessMitigation -System -Disable CFG >NUL 2>&1
for /f "tokens=3 skip=2" %%a in ('reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions"') do set mitigation_mask=%%a
for /L %%a in (0,1,9) do (
    set mitigation_mask=!mitigation_mask:%%a=2!
)
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t reg_BINARY /d "%mitigation_mask%" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t reg_BINARY /d "%mitigation_mask%" /f >NUL 2>&1


:: ASLR - find ntoskrnl strings
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t reg_DWORD /d "0" /f >NUL 2>&1


:: Spectre & Meltdown
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettings /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t reg_DWORD /d "3" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t reg_DWORD /d "3" /f >NUL 2>&1


:::::::::::::::
::Mitigations::
:::::::::::::::


:: DWM
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t reg_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t reg_DWORD /d "0" /f >NUL 2>&1



:: Visual
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >NUL 2>&1
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >NUL 2>&1



:: Security Tweaks 
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters" /v "RestrictNullSessAccess" /t reg_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters" /v "DisableCompression" /t reg_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t reg_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t reg_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t reg_DWORD /d "2" /f >NUL 2>&1



:: Restrict Windows communication
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InternetManagement" /v "RestrictCommunication" /t REG_DWORD /d "1" /f



:: Win32PrioritySeparation 26 hex/38 dec
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t reg_DWORD /d "38" /f >NUL 2>&1


:: Hibernate
powercfg /h off >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t reg_DWORD /d "0" /f >NUL 2>&1


:: MMCSS
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t reg_DWORD /d "10" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t reg_DWORD /d "10" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t reg_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t reg_DWORD /d "10000" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t reg_SZ /d "True" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "NoLazyMode" /t reg_DWORD /d "1" /f >NUL 2>&1




:: Hung Apps, Wait to Kill, QoL
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >NUL 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >NUL 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f >NUL 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9A12038010000000" /f >NUL 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f >NUL 2>&1



:: Enable Hardware Accelerated Scheduling (HAGS)
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t reg_DWORD /d "2" /f >NUL 2>&1



:: Mouse Optimizations
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t reg_SZ /d "10" /f >NUL 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t reg_SZ /d "0" /f >NUL 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t reg_SZ /d "0" /f >NUL 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t reg_SZ /d "0" /f >NUL 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t reg_BINARY /d 0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000 /f >NUL 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t reg_BINARY /d 0000000000000000000038000000000000007000000000000000A800000000000000E00000000000 /f >NUL 2>&1




:: Keyboard Optimizations
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f >NUL 2>&1





:: Data Queue Sizes
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "50" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "50" /f >NUL 2>&1



:: Disable Transparency
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t reg_DWORD /d "0" /f >NUL 2>&1



:: Disable Maintenance
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f >NUL 2>&1



:: Do not reduce sounds while calling
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f >NUL 2>&1
 


:: Handwriting Telemtry
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >NUL 2>&1



:: Windows Error Reporting
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f >NUL 2>&1 
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f >NUL 2>&1



:: Telemetry
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >NUL 2>&1



:: Disable Sleep Study
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f >NUL 2>&1



:: KMS Data sending
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f >NUL 2>&1 



:: Delete Defaultuser0 used during OOBE
net user defaultuser0 /delete >NUL 2>&1 



:: Disable "Administrator" used using OEM
net user administrator /active:no >NUL 2>&1 

::::::::::::
::Internet::
::::::::::::


::Disable Nagle's Algorithm
reg add "HKLM\Software\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t reg_DWORD /d "00000001" /f >NUL 2>&1  
for /f %%s in ('reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s') do set "str=%%i" & if "!str:ServiceName_=!" neq "!str!" (
 	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TCPNoDelay" /t reg_DWORD /d "1" /f >NUL 2>&1
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpAckFrequency" /t reg_DWORD /d "1" /f >NUL 2>&1
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpDelAckTicks" /t reg_DWORD /d "0" /f >NUL 2>&1
)


:: Set max port to 65535
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t reg_DWORD /d "00065534" /f >NUL 2>&1

:: Reduce TIME_WAIT
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t reg_DWORD /d "00000030" /f >NUL 2>&1


:: Disable the TCP autotuning diagnostic tool
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t reg_DWORD /d "00000000" /f >NUL 2>&1

:: Enable TCP Extensions for High Performance
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "00000001" /f >NUL 2>&1 


:: Detect congestion fail to receive acknowledgement for a packet within the estimated timeout
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t reg_DWORD /d "00000001" /f >NUL 2>&1


:: Set the maximum number of concurrent connections (per server endpoint) allowed when making requests using an HttpClient object.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t reg_DWORD /d "00000016" /f >NUL 2>&1


:: Maximum number of HTTP 1.0 connections to a Web server
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t reg_DWORD /d "00000016" /f >NUL 2>&1

:: TCP Congestion Control/Avoidance Algorithm
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >NUL 2>&1


:: QOS
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t reg_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "00000000" /f >NUL 2>&1
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t reg_DWORD /d "0" /f >NUL 2>&1

::Network Priorities
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t reg_DWORD /d "4" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t reg_DWORD /d "5" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t reg_DWORD /d "6" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t reg_DWORD /d "7" /f >NUL 2>&1


::Enable The Network Adapter Onboard Processor
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t reg_DWORD /d "0" /f >NUL 2>&1


::Netsh
powershell -NoProfile -Command "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_pacer, ms_server" >NUL 2>&1

:: NIC Settings - imbiriy
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /v "*SpeedDuplex" /s ^| findstr  "HKEY"') do (
    for /f %%i in ('reg query "%%a" /v "*ReceiveBuffers" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*ReceiveBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*TransmitBuffers" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*DeviceSleepOnDisconnect" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*DeviceSleepOnDisconnect" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*EEE" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*EEE" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*ModernStandbyWoLMagicPacket" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*ModernStandbyWoLMagicPacket" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*SelectiveSuspend" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*SelectiveSuspend" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*WakeOnMagicPacket" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*WakeOnPattern" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*WakeOnPattern" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "AutoPowerSaveModeEnabled" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "AutoPowerSaveModeEnabled" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "EEELinkAdvertisement" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "EEELinkAdvertisement" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "EeePhyEnable" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "EeePhyEnable" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "EnableGreenEthernet" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "EnableModernStandby" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "EnableModernStandby" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "GigaLite" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "GigaLite" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "PowerDownPll" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "PowerDownPll" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "PowerSavingMode" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "PowerSavingMode" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "ReduceSpeedOnPowerDown" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "ReduceSpeedOnPowerDown" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "S5WakeOnLan" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "S5WakeOnLan" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "SavePowerNowEnabled" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "SavePowerNowEnabled" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "ULPMode" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "ULPMode" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "WakeOnLink" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "WakeOnLink" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "WakeOnSlot" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "WakeOnSlot" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "WakeUpModeCap" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "WakeUpModeCap" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "WakeUpModeCap" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "PnPCapabilities" /t REG_SZ /d "24" /f >nul 2>&1
    )
) >nul 2>&1

::::::::::::::
::GPU Tweaks::
::::::::::::::

:: DXKrnl
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v DpiMapIommuContiguous /t REG_DWORD /d 1 /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "CreateGdiPrimaryOnSlaveGPU" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DriverSupportsCddDwmInterop" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncDxAccess" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncGPUAccess" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCreateSwapChain" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkFreeGpuVirtualAddress" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkOpenSwapChain" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkShareSwapChainObject" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent2" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "SwapChainBackBuffer" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "TdrResetFromTimeoutAsync" /t REG_DWORD /d "1" /f >NUL 2>&1

rem No sense adding more, because all depends on the GPU, which settings can be replaced by the driver.

:::::::::::::::
::Main Tweaks::
:::::::::::::::

:: MSI MODE
:: SET TO UNDEFINED
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI"^| findstr "HKEY"') do (
	for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do reg delete "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >NUL 2>&1
)

:: SET FOR NETWORK ADAPTER
for /f %%a in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t reg_DWORD /d "1" /f >NUL 2>&1
)

:: SET FOR USB
for /f %%a in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t reg_DWORD /d "1" /f >NUL 2>&1
)

:: SET FOR GPU
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /f >NUL 2>&1
for /f %%a in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t reg_DWORD /d "1" /f >NUL 2>&1
)

:: Power Saving
for /f "tokens=*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t reg_DWORD /d "0" /f >NUL 2>&1
for /f "tokens=*" %%i in ('wmic PATH Win32_PnPEntity GET DeviceID ^| findstr "USB\VID_"') do (
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t reg_DWORD /d "0" /f >NUL 2>&1
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t reg_DWORD /d "0" /f >NUL 2>&1
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t reg_DWORD /d "0" /f >NUL 2>&1
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t reg_DWORD /d "0" /f >NUL 2>&1
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t reg_DWORD /d "0" /f >NUL 2>&1
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t reg_DWORD /d "0" /f >NUL 2>&1 >NUL 2>&1
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t reg_DWORD /d "0" /f >NUL 2>&1
)

:: Import and set the powerplan
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a >NUL 2>&1
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >NUL 2>&1
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 >NUL 2>&1

:: Power
if %LAPTOP%==0 (
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Storage" /v "StorageD3InModernStandby" /t REG_DWORD /d "0" /f >NUL 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d "0" /f >NUL 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\pci\Parameters" /v "ASPMOptOut" /t REG_DWORD /d "1" /f >NUL 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "IdlePowerMode" /t REG_DWORD /d "0" /f >NUL 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >NUL 2>&1
	for %%a in (AllowIdleIrpInD3 D3ColdSupported DeviceSelectiveSuspended EnableIdlePowerManagement	EnableSelectiveSuspend
		EnhancedPowerManagementEnabled IdleInWorkingState SelectiveSuspendEnabled SelectiveSuspendOn WaitWakeEnabled 
		WakeEnabled WdfDirectedPowerTransitionEnable) do (
		for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%a" ^| findstr "HKEY"') do (
			reg add "%%b" /v "%%a" /t REG_DWORD /d "0" /f >NUL 2>&1
		)
	)
) else (
	powercfg /s 381b4222-f694-41f0-9685-ff5bb260df2e >NUL 2>&1
)

:: CPU
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v CursorSensitivity /t REG_DWORD /d 00002710 /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v CursorUpdateInterval /t REG_DWORD /d 1 /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v IRRemoteNavigationDelta /t REG_DWORD /d 1 /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v AttractionRectInsetInDIPS /t REG_DWORD /d 00000005 /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v DistanceThresholdInDIPS /t REG_DWORD /d 00000028 /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v MagnetismDelayInMilliseconds /t REG_DWORD /d 00000032 /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v MagnetismUpdateIntervalInMilliseconds /t REG_DWORD /d 00000010 /f >NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v VelocityInDIPSPerSecond /t REG_DWORD /d 00000168 /f >NUL 2>&1

:: BCDEDIT
bcdedit /deletevalue useplatformclock > NUL 2>&1
bcdedit /set disabledynamictick yes > NUL 2>&1
bcdedit /set useplatformtick yes > NUL 2>&1
bcdedit /timeout 10 > NUL 2>&1
bcdedit /set bootux disabled > NUL 2>&1
bcdedit /set bootmenupolicy standard > NUL 2>&1
bcdedit /set hypervisorlaunchtype off > NUL 2>&1
bcdedit /set tpmbootentropy ForceDisable > NUL 2>&1
bcdedit /set quietboot yes > NUL 2>&1
bcdedit /set {globalsettings} custom:16000067 true > NUL 2>&1
bcdedit /set {globalsettings} custom:16000069 true > NUL 2>&1
bcdedit /set {globalsettings} custom:16000068 true > NUL 2>&1
bcdedit /set {current} recoveryenabled no > NUL 2>&1
bcdedit /set {current} description DuckOS


:: Disable Devices through DevManView
devmanview /disable "System Speaker" MemoryDiagnostic
devmanview /disable "System Timer"
devmanview /disable "UMBus Root Bus Enumerator"
devmanview /disable "Microsoft System Management BIOS Driver"
devmanview /disable "High Precision Event Timer"
devmanview /disable "PCI Encryption/Decryption Controller"
devmanview /disable "AMD PSP"
devmanview /disable "Intel SMBus"
devmanview /disable "Intel Management Engine"
devmanview /disable "PCI Memory Controller"
devmanview /disable "PCI standard RAM Controller"
devmanview /disable "Microsoft Kernel Debug Network Adapter"
devmanview /disable "SM Bus Controller"
devmanview /disable "NDIS Virtual Network Adapter Enumerator"
devmanview /disable "Numeric Data Processor"
devmanview /disable "Microsoft RRAS Root Enumerator"
devmanview /disable "WAN Miniport (IKEv2)"
devmanview /disable "WAN Miniport (IP)"
devmanview /disable "WAN Miniport (IPv6)"
devmanview /disable "WAN Miniport (L2TP)"
devmanview /disable "WAN Miniport (Network Monitor)"
devmanview /disable "WAN Miniport (PPPOE)"
devmanview /disable "WAN Miniport (PPTP)"
devmanview /disable "WAN Miniport (SSTP)"


:: Disable unneeded Tasks
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineCore" >NUL 2>&1
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineUA" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Autochk\Proxy" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskregistrationMaintenanceTask" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\StorageSense" >NUL 2>&1
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateBrowserReplacementTask" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\registry\regIdleBackup" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnLoltartTypeChange" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Report policies" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Work" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\UPnP\UPnPHostConfig" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdates" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\SmartRetry" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Printing\EduPrintProv" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Ras\MobilityManager" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\PushToInstall\LoginCheck" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Diagnosis\Scheduled" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Wininet\CacheTask" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Setup\Metadata Refresh" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" >NUL 2>&1
schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" >NUL 2>&1

:::::::::::::::::
:: CLEANING UP ::
:::::::::::::::::

:: Cleanup after MS EDGE
sc delete edgeupdate >NUL 2>&1
sc delete edgeupdatem >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\Classes\MSEdgeHTM" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\EventLog\Application\edgeupdate" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\EventLog\Application\edgeupdatem" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Clients\StartMenuInternet\Microsoft Edge" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\EdgeUpdate" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Edge" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\Clients\StartMenuInternet\Microsoft Edge" /f >NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Device Metadata" /f >NUL 2>&1

:: Misc Tweaks
lodctr /r >nul 2>&1

:: Clear the screen.. not a tweak.
cls
echo Please wait, this may take a moment.
SETLOCAL EnableDelayedExpansion

:: change ntp server from windows server to pool.ntp.org
sc config W32Time start=demand >nul 2>nul
sc start W32Time >nul 2>nul
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
sc queryex "w32time"|Find "STATE"|Find /v "RUNNING"||(
    net stop w32time
    net start w32time
) >nul 2>nul

:: resync time to pool.ntp.org
w32tm /config /update
w32tm /resync
sc stop W32Time
sc config W32Time start=disabled

:: RUN CACHE CLEANER ON STARTUP
schtasks /create /f /sc ONLOGON /ru "nt authority\system" /tn "\DuckOS Cache Cleaner" /tr "\"%ProgramData%\cache-cleaner.bat\"" /delay 0000:30 >nul 2>&1

:: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/language-packs-known-issue
schtasks /Change /Disable /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" >nul 2>nul
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Control Panel\International" /v "BlockCleanupOfUnusedPreinstalledLangPacks" /t REG_DWORD /d "1" /f

:: Disable unneeded Tasks
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineCore" >nul 2>nul
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineUA" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Autochk\Proxy" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" >nul 2>nul
:: Breaks setting Lock Screen
:: schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\CreateObjectTask"
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" >nul 2>nul
:: Should already be disabled
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Report policies" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Work" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UPnP\UPnPHostConfig" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdates" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\SmartRetry" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Printing\EduPrintProv" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Ras\MobilityManager" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\PushToInstall\LoginCheck" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Diagnosis\Scheduled" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Wininet\CacheTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Setup\Metadata Refresh" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" >nul 2>nul
cls
echo Please wait. This may take a moment.

:: Delete Adobe Font Type Manager
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f

:: Disable USB Autorun/play
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f

:: Disable Camera Access when locked
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f

:: Disable Remote Assistance
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Remote Assistance" /v "fEnableChatControl" /t REG_DWORD /d "0" /f

:: Mitigate against HiveNightmare/SeriousSAM
icacls %windir%\system32\config\*.* /inheritance:e

:: Set strong cryptography on 64 bit and 32 bit .Net Framework (version 4 and above) to fix a Scoop installation issue
:: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f

:: Disable Network Navigation pane in file explorer
reg add "HKEY_CLASSES_ROOT\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2962489444 /f



:: Import the powerplan
powercfg -import "C:\Windows\DuckModules\Duck.pow" 11111111-1111-1111-1111-111111111111
powercfg /s 11111111-1111-1111-1111-111111111111

:: tokens arg breaks path to just \Device instead of \Device Parameters
:: Disable Power savings on drives
for /f "tokens=*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f
powershell -NoProfile -Command "$devices = Get-WmiObject Win32_PnPEntity; $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($p in $powerMgmt){$IN = $p.InstanceName.ToUpper(); foreach ($h in $devices){$PNPDI = $h.PNPDeviceID; if ($IN -like \"*$PNPDI*\"){$p.enable = $False; $p.psbase.put()}}}" >nul 2>nul

:: Make certain applications in the DuckModules folder request UAC
:: Although these applications may already request UAC, setting this compatibility flag ensures they are ran as administrator
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\DuckModules\serviwin.exe" /t REG_SZ /d "~ RUNASADMIN" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\DuckModules\DevManView.exe" /t REG_SZ /d "~ RUNASADMIN" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\DuckModules\nsudo.exe.exe" /t REG_SZ /d "~ RUNASADMIN" /f


cls
echo Please wait. This may take a moment.

:: Unhide powerplan attributes
:: Credits to: Eugene Muzychenko
for /f "tokens=1-9* delims=\ " %%A in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings /s /f attributes /e') do (
  if /i "%%A" == "HKEY_LOCAL_MACHINE" (
    set Ident=
    if not "%%G" == "" (
      set Err=
      set Group=%%G
      set Setting=%%H
      if "!Group:~35,1!" == "" set Err=group
      if not "!Group:~36,1!" == "" set Err=group
      if not "!Setting!" == "" (
        if "!Setting:~35,1!" == "" set Err=setting
        if not "!Setting:~36,1!" == "" set Err=setting
        Set Ident=!Group!:!Setting!
      ) else (
        Set Ident=!Group!
      )
      if not "!Err!" == "" (
        echo ***** Error in !Err! GUID: !Ident"
      )
    )
  ) else if "%%A" == "Attributes" (
    if "!Ident!" == "" (
      echo ***** No group/setting GUIDs before Attributes value
    )
    set /a Attr = %%C
    set /a Hidden = !Attr! ^& 1
    if !Hidden! equ 1 (
      echo Unhiding !Ident!
      powercfg -attributes !Ident::= ! -attrib_hide
    )
  )
)

:: Residual File Cleanup
:: Files are removed in official ISO
del /F /Q "%WinDir%\System32\GameBarPresenceWriter.exe" >nul 2>nul
del /F /Q "%WinDir%\System32\mobsync.exe" >nul 2>nul
del /F /Q "%WinDir%\System32\mcupdate_genuineintel.dll" >nul 2>nul
del /F /Q "%WinDir%\System32\mcupdate_authenticamd.dll" >nul 2>nul
:: Remove Edge
rmdir /s /q "C:\Program Files (x86)\Microsoft" >nul 2>nul
:: Remove residual registry keys
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\Classes\MSEdgeHTM" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\EventLog\Application\edgeupdate" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\EventLog\Application\edgeupdatem" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Clients\StartMenuInternet\Microsoft Edge" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\EdgeUpdate" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Edge" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\Clients\StartMenuInternet\Microsoft Edge" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Device Metadata" /f >nul 2>nul

:: go away

reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f

:: network stuff go away

netsh int tcp set heuristics disabled
netsh int tcp set supplemental Internet congestionprovider=ctcp
netsh int tcp set global timestamps=disabled
netsh int tcp set global rsc=disabled
for /f "tokens=1" %%i in ('netsh int ip show interfaces ^| findstr [0-9]') do (
	netsh int ip set interface %%i routerdiscovery=disabled store=persistent
)

:: Windows Server Update Client ID
sc stop wuauserv >nul 2>nul
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v "SusClientId" /t REG_SZ /d "00000000-0000-0000-0000-000000000000" /f

:: disable hibernation
powercfg -h off

:: Disable Network Adapters
:: IPv6, Client for Microsoft Networks, QoS Packet Scheduler, File and Printer Sharing
powershell -NoProfile -Command "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_pacer, ms_server" >nul 2>&1

:: Disable Devices
devmanview /disable "Composite Bus Enumerator"

:: Drivers

reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\3ware" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\ADP80XX" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\AmdK8" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\arcsas" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\AsyncMac" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\bindflt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\buttonconverter" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\CAD" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\cdfs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\CimFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\circlass" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\cnghwassist" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\CompositeBus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dfsc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\ErrDev" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\fdc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\flpydisk" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\fvevol" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\nvraid" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\QWAVEdrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\rdyboost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\srv2" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\sfloppy" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SiSRaid2" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SiSRaid4" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip6" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\tcpipreg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Telemetry" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\udfs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\umbus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\VerifierExt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\vsmraid" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\VSTXRAID" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\wcnfs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\WindowsTrustedRTProxy" /v "Start" /t REG_DWORD /d "4" /f

:: Remove SOME dependencies
:: GO AWAY
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\rdyboost" /v "DependOnService" /t REG_MULTI_SZ /d "" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ  /d "" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ  /d "" /f



:: Registry
:: Done through script now, HKCU\.. keys often don't integrate correctly.


:: BSOD QoL
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f

:: GPO for Startmenu (tiles)
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "C:\Windows\layout.xml" /f

:: Enable dark mode, disable transparency
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f

:: Disable Windows Updates
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AllowAutoWindowsUpdateDownloadOverMeteredNetwork" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableDualScan" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AUPowerManagement" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationDisable" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuilds" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuildsPolicyValue" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdates" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "BranchReadinessLevel" /t REG_DWORD /d "20" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdatesPeriodInDays" /t REG_DWORD /d "365" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUAsDefaultShutdownOption" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUShutdownOption" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "EnableFeaturedSoftware" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "	DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f


:: Disable Speech Model Updates
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f

::Disable Windows Insider and Build Previews
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f


::  Maps Updates/Downloads
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f

:: Disable CEIP
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f

:: Disable Windows Media Player DRM Online Access
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f

:: Disable Web in Search
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f


:: Data Queue Sizes
:: Go away!
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "25" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "25" /f


:: Explorer
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f
:: Old Alt Tab
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f


:: Application Compatability
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f


:: Disable Mouse Acceleration
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f




:: Disable Annoying Keyboard Features
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f

:: Disable Connection Checking (pings Microsoft Servers)
:: May cause internet icon to show it is disconnected
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t REG_DWORD /d "0" /f

:: Restrict Windows' access to internet resources
:: Enables various other GPOs that limit access on specific windows services
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InternetManagement" /v "RestrictCommunication" /t REG_DWORD /d "1" /f

:: Disable Text/Ink/Handwriting Telemetry
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f


:: Disable Windows Error Reporting
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f


:: Disable Data Collection
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f

:: Misc
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f

:: Content Delivery Manager
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314563Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f

:: Advertising Info
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f


:: Disable Sleep Study
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f


:: Opt-out of sending KMS client activation data to Microsoft automatically. Enabling this setting prevents this computer from sending data to Microsoft regarding its activation state.
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f


:: Disable Feedback
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f

:: Disable Settings Sync
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f


:: Power
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f


:: Location Tracking
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f


:: remove readyboost tab
reg delete "HKEY_CLASSES_ROOT\Drive\shellex\PropertySheetHandlers\{55B3A0BD-4D28-42fe-8CFB-FA3EDFF969B8}" /f >nul 2>nul



:: Hide "Meet Now" button. For future proofing
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f

:: Disable Shared Experiences
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f

:: Internet Explorer QoL
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Main" /v "NoUpdateCheck" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Main" /v "Enable Browser Extensions" /t REG_SZ /d "no" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Main" /v "Isolation" /t REG_SZ /d "PMEM" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer" /v "DisableFlashInIE" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableFixSecuritySettings" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "EnableInPrivateBrowsing" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Main" /v "EnableAutoUpgrade" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Main" /v "HideNewEdgeButton" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Feed Discovery" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Feeds" /v "BackgroundSyncStatus" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\FlipAhead" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing" /v "NewTabPageShow" /t REG_DWORD /d "1" /f

:: show all tasks on control panel, credits to tenforums
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "InfoTip" /t REG_SZ /d "View list of all Control Panel tasks" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "System.ControlPanel.Category" /t REG_SZ /d "5" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\imageres.dll,-27" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\Shell\Open\Command" /ve /t REG_SZ /d "explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f


:: Memory Management
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f


:: Disable Fault Tolerant Heap
:: https://docs.microsoft.com/en-us/windows/win32/win7appqual/fault-tolerant-heap
:: Doc listed as only affected in windows 7, is also in 7+
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f


:: Find correct mitigation values for different windows versions - AMIT
:: initialize bit mask in registry by disabling a random mitigation
powershell -NoProfile -Command Set-ProcessMitigation -System -Disable CFG

reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "%mitigation_mask%" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "%mitigation_mask%" /f

:: https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f

:: MMCSS
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "10000" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "NoLazyMode" /t REG_DWORD /d "1" /f

:: GameBar/FSE
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f

:: Disallow Background Apps
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f

:: Set Win32PrioritySeparation 26 hex/38 dec
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f

:: Disable Notification/Action Center
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f

:: Hung Apps, Wait to Kill, QoL
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9A12038010000000" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f

:: Visual
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f

:: DWM
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f
:: Needs testing
:: https://djdallmann.github.io/GamingPCSetup/CONTENT/RESEARCH/FINDINGS/registrykeys_dwm.txt
:: add batch to new file menu
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f

:: add reg to new file menu
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f

:: Disable Storage Sense
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\StorageSense" /v "AllowStorageSenseGlobal" /t REG_DWORD /d "0" /f

:: Disable Maintenance
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f

:: Do not reduce sounds while in a call
C:\Windows\DuckModules\nsudo.exe -U:C -P:E -Wait reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f

:: Edge
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d "0" /f

:: install cab context menu
reg delete "HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs" /f >nul 2>nul
reg add "HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f
reg add "HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f
reg add "HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k dism /online /add-package /packagepath:\"%%1\"" /f

:: "Merge as TrustedInstaller" for .regs
reg add "HKEY_CLASSES_ROOT\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As TrustedInstaller" /f
reg add "HKEY_CLASSES_ROOT\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f
reg add "HKEY_CLASSES_ROOT\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "nsudo -U:T -P:E reg import "%%1"" /f

:: add run with priority context menu
reg add "HKEY_CLASSES_ROOT\exefile\shell\Priority" /v "MUIVerb" /t REG_SZ /d "Run with priority" /f
reg add "HKEY_CLASSES_ROOT\exefile\shell\Priority" /v "SubCommands" /t REG_SZ /d "" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\001flyout" /ve /t REG_SZ /d "Realtime" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\001flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Realtime \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\002flyout" /ve /t REG_SZ /d "High" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\002flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /High \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\003flyout" /ve /t REG_SZ /d "Above normal" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\003flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /AboveNormal \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\004flyout" /ve /t REG_SZ /d "Normal" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\004flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Normal \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\005flyout" /ve /t REG_SZ /d "Below normal" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\005flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /BelowNormal \"%%1\"" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\006flyout" /ve /t REG_SZ /d "Low" /f
reg add "HKEY_CLASSES_ROOT\exefile\Shell\Priority\shell\006flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Low \"%%1\"" /f

:: remove include in library context menu
reg delete "HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>nul

:: Remove Share in context menu
reg delete "HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\ModernSharing" /f >nul 2>nul

:: double click to import power plans
reg add "HKEY_LOCAL_MACHINE\Software\Classes\powerplan\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\powercpl.dll,1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\powerplan\Shell\open\command" /ve /t REG_SZ /d "powercfg /import \"%%1\"" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.pow" /ve /t REG_SZ /d "powerplan" /f
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.pow" /v "FriendlyTypeName" /t REG_SZ /d "PowerPlan" /f

:: set CSRSS to high
:: csrss is responsible for mouse input, setting to high may yield an improvement in input latency.
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f

cd %windows%\DuckModules
powershell -NoProfile -EP Bypass .\devices.ps1 

:: Finish

reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\2674077835" /v "EnabledState" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\2674077835" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171" /v "EnabledState" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell" /v "BagMRU Size" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
sc config BITS start=demand >nul 2>&1
sc config cdfs start=demand >nul 2>&1
sc config CryptSvc start=demand >nul 2>&1
sc config mssmbios start=demand >nul 2>&1
sc config ShellHWDetection start=disabled >nul 2>&1
sc config vdrvroot start=demand >nul 2>&1

:: SWITCH FROM PUBLIC TO PRIVATE FIREWALL
@echo off && cls
powershell -NoProfile "$net=get-netconnectionprofile; Set-NetConnectionProfile -Name $net.Name -NetworkCategory Private" >nul 2>&1

:: REENABLE PROBING
@echo off && cls
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t REG_DWORD /d "1" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "NoActiveProbe" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "DisablePassivePolling" /f >nul 2>&1
reg add "hklm\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 0 /f 
reg add "hklm\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFind /t REG_DWORD /d 0 /f 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d "0" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d "0" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\explorer" /v DisallowRun /t REG_DWORD /d 0 /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\explorer\DisallowRun" /f
shutdown /a
rd /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accessibility" >nul 2>&1
shutdown /r /t 2 /f
