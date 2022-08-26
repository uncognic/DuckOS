@echo off
TITLE Discord Debloat v4 by K3rnelPan1c
echo Introduce tu idioma / Enter your language.
echo ATENCION, ACTUALMENTE NO ESTA DISPONIBLE EL IDIOMA INGLES
SET /P lang="Spanish / English: "
IF /I %lang%=="Spanish" goto spanish
IF /I %lang%=="English" goto english
IF /I %lang%=="spanish" goto spanish
IF /I %lang%=="english" goto english

:spanish
echo Cerrando discord!
powershell.exe Stop-Process -name "discord" -Force
:inicio
cls
echo.
echo Mostrando el directorio de discord
echo.
DIR /B "%HOMEPATH%\AppData\Local\Discord"
echo.
SET /P DisVer="Introduzca su version de discord (ejemplo: app-x.x.xxxx): "
SET Ver=%DisVer:~4%
echo Version: %Ver%
IF EXIST "%HOMEPATH%\AppData\Local\Discord\%DisVer%" (
	echo Version introducida correctamente.
	echo.
	echo Pulse una tecla para continuar.
	pause>nul
	goto debloat
) else (
cls
echo --------------------------------------
echo - INTRODUCE LA VERSION CORRECTAMENTE -
echo --------------------------------------
echo Espere para continuar con el debloat
timeout /t 5 /nobreak >nul
goto inicio
)

:debloat

echo Eliminando cache
::DIRECTORIOS DE CACHE -- Pablerso
RD /S /Q "%USERPROFILE%\AppData\Roaming\discord\Cache" >nul
RD /S /Q "%USERPROFILE%\AppData\Roaming\discord\Code Cache" >nul
RD /S /Q "%USERPROFILE%\AppData\Roaming\discord\Crashpad" >nul
RD /S /Q "%USERPROFILE%\AppData\Roaming\discord\GPUCache" >nul

CHOICE /C YN /M "Te gustaria deshabilitar las actualizaciones completamente? "
IF %ERRORLEVEL% EQU 1 (
echo Eliminando actualizaciones!
DEL "%HOMEPATH%\Desktop\Discord.ink" /F /Q
DEL "%HOMEPATH%\Desktop\Discord.ink - Shortcut" /F /Q
DEL "%HOMEPATH%\Desktop\Update.exe" /F /Q
DEL "%HOMEPATH%\Desktop\Update.exe - Shortcut" /F /Q
DEL "%HOMEPATH%\Desktop\Discord.exe" /F /Q
DEL "%HOMEPATH%\Desktop\Discord.exe - Shortcut" /F /Q
DEL "%HOMEPATH%\AppData\Local\Discord\Update.exe" /F /Q
DEL "%HOMEPATH%\AppData\Local\Discord\%DisVer%\Squirrel.exe" /F /Q
DEL "%HOMEPATH%\AppData\Local\Discord\SquirrelSetup.log" /F /Q
rd /s /q "%HOMEPATH%\appdata\Local\discord\Packages"
)
CLS

CHOICE /C YN /M "Te gustaria eliminar los idiomas?"
IF %ERRORLEVEL% EQU 1 (
echo Eliminando idiomas
::Eliminar diccionarios
powershell.exe Move-Item -Path '%USERPROFILE%\AppData\Roaming\discord\Dictionaries\es-ES-3-0.bdic' -Destination '%temp%' -Force >NUL 2>&1
powershell.exe Move-Item -Path '%USERPROFILE%\AppData\Roaming\discord\Dictionaries\en-US-9-0.bdic' -Destination '%temp%' -Force >NUL 2>&1
timeout /t 5 /nobreak >nul
del /f /q "%USERPROFILE%\AppData\Roaming\discord\Dictionaries\*"
timeout /t 5 /nobreak >nul
powershell.exe Move-Item -Path '%temp%\es-ES-3-0.bdic' -Destination '%USERPROFILE%\AppData\Roaming\discord\Dictionaries\' -Force
powershell.exe Move-Item -Path '%temp%\en-US-9-0.bdic' -Destination '%USERPROFILE%\AppData\Roaming\discord\Dictionaries\en-US-9-0.bdic' -Force
timeout /t 5 /nobreak >nul

::Eliminar idiomas
powershell.exe Move-Item -Path '%USERPROFILE%\AppData\Local\Discord\%DisVer%\locales\es.pak' -Destination '%temp%' -Force
powershell.exe Move-Item -Path '%USERPROFILE%\AppData\Local\Discord\%DisVer%\locales\es-419.pak' -Destination '%temp%' -Force
powershell.exe Move-Item -Path '%USERPROFILE%\AppData\Local\Discord\%DisVer%\locales\en-US.pak' -Destination '%temp%' -Force
timeout /t 5 /nobreak >nul
del /f /q "%USERPROFILE%\AppData\Local\Discord\%DisVer%\locales\*"
timeout /t 5 /nobreak >nul
powershell.exe Move-Item -Path '%temp%\es.pak' -Destination '%USERPROFILE%\AppData\Local\Discord\%DisVer%\locales\' -Force
powershell.exe Move-Item -Path '%temp%\es-419.pak' -Destination '%USERPROFILE%\AppData\Local\Discord\%DisVer%\locales\' -Force
powershell.exe Move-Item -Path '%temp%\en-US.pak' -Destination '%USERPROFILE%\AppData\Local\Discord\%DisVer%\locales\' -Force
)
cls

CHOICE /C YN /M "Te gustaria deblotear Discord?"
IF %ERRORLEVEL% EQU 1 (
@echo Removiendo BloatWare!
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_cloudsync-1"
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_dispatch-1"
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_erlpack-1"
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_game_utils-1"
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_media-1"
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_spellcheck-1"
CLS
@echo Listo!)

CHOICE /C YN /M "Usas la supresion de ruido?"
IF %ERRORLEVEL% EQU 2 (
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_krisp-1"
CLS
echo Listo!)

CHOICE /C YN /M "Te gustaria remover el Overlay?"
IF %ERRORLEVEL% EQU 1 (
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_rpc-1"
rd /s /q "%HOMEPATH%\AppData\Local\Discord\%DisVer%\modules\discord_overlay2-1"
CLS
echo Listo!)

echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%HOMEDRIVE%%HOMEPATH%\Desktop\Discord.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%HOMEPATH%\AppData\Local\Discord\%DisVer%\Discord.exe" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs
del CreateShortcut.vbs
CLS
echo Todo Listo!
echo.
echo LUEGO DE EJECUTAR EL ARCHIVO BATCH, TIENES QUE INICIAR DISCORD DESDE EL ACCESO DIRECTO DEL ESCRITORIO.
echo Discord Debloat v4 by K3rnelPan1c#5750
start https://twitter.com/KernelPan1c5750
echo Presione una tecla para finalizar.
pause>nul
exit