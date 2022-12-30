@echo off
@title hosts clearer
choice /n /m Do you want to reset hosts file to system default? [Y/N]
if errorlevel 1 (
    set h=%windir%\system32\drivers\etc\hosts
    echo # Copyright (c) 1993-2009 Microsoft Corp. > %h%
    echo # >> %h%
    echo # This is a sample HOSTS file used by Microsoft TCP/IP for Windows. >> %h%
    echo # >> %h%
    echo # This file contains the mappings of IP addresses to host names. Each >> %h%
    echo # entry should be kept on an individual line. The IP address should >> %h%
    echo # be placed in the first column followed by the corresponding host name. >> %h%
    echo # The IP address and the host name should be separated by at least one >> %h%
    echo # space. >> %h%
    echo # >> %h%
    echo # Additionally, comments (such as these) may be inserted on individual >> %h%
    echo # lines or following the machine name denoted by a '#' symbol. >> %h%
    echo # >> %h%
    echo # For example: >> %h%
    echo # >> %h%
    echo #      102.54.94.97     rhino.acme.com          # source server >> %h%
    echo #       38.25.63.10     x.acme.com              # x client host >> %h%
    echo. >> %h%
    echo # localhost name resolution is handled within DNS itself. >> %h%
    echo #	127.0.0.1       localhost >> %h%
    echo #	::1             localhost >> %h%
) else (
    echo No changes have been made to your hosts file. Press any key to quit.
    pause >nul & exit
)
