@echo off
@title hosts clearer
choice /n /m Do you want to reset hosts file to system default? [Y/N]
if errorlevel 1 (
    set h=%h%\drivers\etc
    echo # Copyright (c) 1993-2009 Microsoft Corp. > %h%\hosts
    echo # >> %h%\hosts
    echo # This is a sample HOSTS file used by Microsoft TCP/IP for Windows. >> %h%\hosts
    echo # >> %h%\hosts
    echo # This file contains the mappings of IP addresses to host names. Each >> %h%\hosts
    echo # entry should be kept on an individual line. The IP address should >> %h%\hosts
    echo # be placed in the first column followed by the corresponding host name. >> %h%\hosts
    echo # The IP address and the host name should be separated by at least one >> %h%\hosts
    echo # space. >> %h%\hosts
    echo # >> %h%\hosts
    echo # Additionally, comments (such as these) may be inserted on individual >> %h%\hosts
    echo # lines or following the machine name denoted by a '#' symbol. >> %h%\hosts
    echo # >> %h%\hosts
    echo # For example: >> %h%\hosts
    echo # >> %h%\hosts
    echo #      102.54.94.97     rhino.acme.com          # source server >> %h%\hosts
    echo #       38.25.63.10     x.acme.com              # x client host >> %h%\hosts
    echo. >> %h%\hosts
    echo # localhost name resolution is handled within DNS itself. >> %h%\hosts
    echo #	127.0.0.1       localhost >> %h%\hosts
    echo #	::1             localhost >> %h%\hosts
) else (
    echo No changes have been made to your hosts file. Press any key to quit.
    pause >nul & exit
)
