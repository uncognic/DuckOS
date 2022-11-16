@echo off
cls
color e
title Spotify Debloater + Ad removal tool
choice /n /m Do you want to debloat Spotify and have a break from the ads... forever? [Y/N]
if errorlevel 1 (
    echo.
    echo $ Downloading Spotify + blocking ads and debloating it..
    %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/SpotX-CLI/SpotX-Win/main/Install.ps1').Content | Invoke-Expression}"
    echo $ Installation done.
    echo $ Terminating Spotify if it's running...
    taskkill /f /im spotify.exe
	echo $ Initializing
	:: set varables for lowering file size -william
	set ms=%appdata%\Spotify
    echo $ Debloating...
    del /f /q /s "%ms%\SpotifyMigrator.exe"
    del /f /q /s "%ms%\SpotifyStartupTask.exe"
    del /f /q /s "%ms%\Apps\Buddy-list.spa"
    del /f /q /s "%ms%\Apps\Concert.spa"
    del /f /q /s "%ms%\Apps\Concerts.spa"
    del /f /q /s "%ms%\Apps\Error.spa"
    del /f /q /s "%ms%\Apps\Findfriends.spa"
    del /f /q /s "%ms%\Apps\Legacy-lyrics.spa"
    del /f /q /s "%ms%\Apps\Lyrics.spa"
    del /f /q /s "%ms%\Apps\Show.spa"
    del /f /q /s "%ms%\Apps\Buddy-list.spa"
    del /f /q /s "%ms%\locales\am.pak"
    del /f /q /s "%ms%\locales\ar.mo"
    del /f /q /s "%ms%\locales\ar.pak"
    del /f /q /s "%ms%\locales\bg.pak"
    del /f /q /s "%ms%\locales\bn.pak"
    del /f /q /s "%ms%\locales\ca.pak"
    del /f /q /s "%ms%\locales\cs.mo"
    del /f /q /s "%ms%\locales\cs.pak"
    del /f /q /s "%ms%\locales\da.pak"
    del /f /q /s "%ms%\locales\de.mo"
    del /f /q /s "%ms%\locales\de.pak"
    del /f /q /s "%ms%\locales\el.mo"
    del /f /q /s "%ms%\locales\el.pak"
    del /f /q /s "%ms%\locales\en-GB.pak"
    del /f /q /s "%ms%\locales\es.mo"
    del /f /q /s "%ms%\locales\es.pak"
    del /f /q /s "%ms%\locales\es-419.mo"
    del /f /q /s "%ms%\locales\es-419.pak"
    del /f /q /s "%ms%\locales\et.pak"
    del /f /q /s "%ms%\locales\fa.pak"
    del /f /q /s "%ms%\locales\fi.mo"
    del /f /q /s "%ms%\locales\fi.pak"
    del /f /q /s "%ms%\locales\fil.pak"
    del /f /q /s "%ms%\locales\fr.mo"
    del /f /q /s "%ms%\locales\fr.pak"
    del /f /q /s "%ms%\locales\fr-CA.mo"
    del /f /q /s "%ms%\locales\gu.pak"
    del /f /q /s "%ms%\locales\he.mo"
    del /f /q /s "%ms%\locales\he.pak"
    del /f /q /s "%ms%\locales\hi.pak"
    del /f /q /s "%ms%\locales\hr.pak"
    del /f /q /s "%ms%\locales\hu.mo"
    del /f /q /s "%ms%\locales\hu.pak"
    del /f /q /s "%ms%\locales\id.mo"
    del /f /q /s "%ms%\locales\id.pak"
    del /f /q /s "%ms%\locales\it.mo"
    del /f /q /s "%ms%\locales\it.pak"
    del /f /q /s "%ms%\locales\ja.mo"
    del /f /q /s "%ms%\locales\ja.pak"
    del /f /q /s "%ms%\locales\kn.pak"
    del /f /q /s "%ms%\locales\ko.mo"
    del /f /q /s "%ms%\locales\ko.pak"
    del /f /q /s "%ms%\locales\lt.pak"
    del /f /q /s "%ms%\locales\lv.pak"
    del /f /q /s "%ms%\locales\ml.pak"
    del /f /q /s "%ms%\locales\mr.pak"
    del /f /q /s "%ms%\locales\ms.mo"
    del /f /q /s "%ms%\locales\ms.pak"
    del /f /q /s "%ms%\locales\nb.pak"
    del /f /q /s "%ms%\locales\nl.mo"
    del /f /q /s "%ms%\locales\nl.pak"
    del /f /q /s "%ms%\locales\pl.mo"
    del /f /q /s "%ms%\locales\pl.pak"
    del /f /q /s "%ms%\locales\pt-PT.pak"
    del /f /q /s "%ms%\locales\pt-BR.pak"
    del /f /q /s "%ms%\locales\pt-BR.mo"
    del /f /q /s "%ms%\locales\ro.pak"
    del /f /q /s "%ms%\locales\ru.mo"
    del /f /q /s "%ms%\locales\ru.pak"
    del /f /q /s "%ms%\locales\sk.pak"
    del /f /q /s "%ms%\locales\sl.pak"
    del /f /q /s "%ms%\locales\sr.pak"
    del /f /q /s "%ms%\locales\sv.mo"
    del /f /q /s "%ms%\locales\sv.pak"
    del /f /q /s "%ms%\locales\sw.pak"
    del /f /q /s "%ms%\locales\ta.pak"
    del /f /q /s "%ms%\locales\te.pak"
    del /f /q /s "%ms%\locales\th.mo"
    del /f /q /s "%ms%\locales\th.pak"
    del /f /q /s "%ms%\locales\tr.mo"
    del /f /q /s "%ms%\locales\tr.pak"
    del /f /q /s "%ms%\locales\uk.pak"
    del /f /q /s "%ms%\locales\vi.mo"
    del /f /q /s "%ms%\locales\vi.pak"
    del /f /q /s "%ms%\locales\zh-CN.pak"
    del /f /q /s "%ms%\locales\zh-Hant.mo"
    del /f /q /s "%ms%\locales\zh-TW.pak"
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f
    cls
    echo $ All done. Press any key to exit.
    pause >nul
) else (
    echo.
    echo $ No changes have been made. Press any key to exit.
    pause >nul & exit
)