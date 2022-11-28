@echo off
cls
color e
title Spotify Debloater + Ad removal tool
choice /n /m Do you want to debloat Spotify and have a break from the ads... forever? [Y/N]
if errorlevel 1 (
    echo.
    echo $ Downloading Spotify + blocking ads and debloating it...
    %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/SpotX-CLI/SpotX-Win/main/Install.ps1').Content | Invoke-Expression}"
    echo $ Installation done.
    echo $ Terminating Spotify if it's running...
    taskkill /f /im spotify.exe
	echo $ Initializing
	:: set variables for lowering file size -william -anhnguyenlost13
	set s=%appdata%\Spotify
	set sa=%s%\Apps
	set sl=%s%\locales
    echo $ Debloating...
    for %%a in ( SpotifyMigrator.exe SpotifyStartupTask.exe ) do (
        del /f /q "%s%\%%a"
    )
    for %%b in ( Buddy-list.spa Concert.spa Concerts.spa Error.spa Findfriends.spa Legacy-lyrics.spa Lyrics.spa Show.spa ) do (
        del /f /q "%sa%\%%b"
    )
    for %%c in ( am.pak ar.mo ar.pak bg.pak bn.pak ca.pak cs.mo cs.pak da.pak de.mo de.pak el.mo el.pak en-GB.pak es.mo es.pak es-419.mo es-419.pak et.pak fa.pak fi.mo fi.pak fil.pak fr.mo fr.pak fr-CA.mo gu.pak he.mo he.pak hi.pak hr.pak hu.mo hu.pak id.mo id.pak it.mo it.pak ja.mo ja.pak kn.pak ko.mo ko.pak lt.pak lv.pak ml.pak mr.pak s.mo s.pak nb.pak nl.mo nl.pak pl.mo pl.pak pt-PT.pak pt-BR.pak pt-BR.mo ro.pak ru.mo ru.pak sk.pak sl.pak sr.pak sv.mo sv.pak sw.pak ta.pak te.pak th.mo th.pak tr.mo tr.pak uk.pak vi.mo vi.pak zh-CN.pak zh-Hant.mo zh-TW.pak ) do (
        del /f /q "%sl%\%%c"
    )
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f
    cls
    echo $ All done. Press any key to exit.
    pause >nul
) else (
    echo.
    echo $ No changes have been made. Press any key to exit.
    pause >nul & exit
)
