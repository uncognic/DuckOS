@echo off
title Increase User VA - Experimental
color b
echo.
echo ------------------
echo - 1. Increase VA -
echo - 2. Default VA  -
echo ------------------
echo.
set /p menu=:
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto default

:enable
bcdedit /set IncreaseUserVA 3072
exit

:default
bcdedit /deletevalue IncreaseUserVA
exit




