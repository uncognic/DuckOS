@echo off
@title hosts clearer
choice /n /m Do you want to reset hosts file to system default? [Y/N]
if errorlevel 1 (
    echo # Copyright (c) 1993-2009 Microsoft Corp. > %windir%\system32\hosts
    echo # >> %windir%\system32\hosts
    echo # This is a sample HOSTS file used by Microsoft TCP/IP for Windows. >> %windir%\system32\hosts
    echo # >> %windir%\system32\hosts
    echo # This file contains the mappings of IP addresses to host names. Each >> %windir%\system32\hosts
    echo # entry should be kept on an individual line. The IP address should >> %windir%\system32\hosts
    echo # be placed in the first column followed by the corresponding host name. >> %windir%\system32\hosts
    echo # The IP address and the host name should be separated by at least one >> %windir%\system32\hosts
    echo # space. >> %windir%\system32\hosts
    echo # >> %windir%\system32\hosts
    echo # Additionally, comments (such as these) may be inserted on individual >> %windir%\system32\hosts
    echo # lines or following the machine name denoted by a '#' symbol. >> %windir%\system32\hosts
    echo # >> %windir%\system32\hosts
    echo # For example: >> %windir%\system32\hosts
    echo # >> %windir%\system32\hosts
    echo #      102.54.94.97     rhino.acme.com          # source server >> %windir%\system32\hosts
    echo #       38.25.63.10     x.acme.com              # x client host >> %windir%\system32\hosts
    echo. >> %windir%\system32\hosts
    echo # localhost name resolution is handled within DNS itself. >> %windir%\system32\hosts
    echo #	127.0.0.1       localhost >> %windir%\system32\hosts
    echo #	::1             localhost >> %windir%\system32\hosts
) else (
    echo No changes have been made to your hosts file. Press any key to quit.
    pause >nul & exit
)
