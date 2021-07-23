@echo off
set /p ipad=Enter IP: 
echo ---------------------------------------
echo  Script is going connect to %ipad%
echo ---------------------------------------
echo Miroslav Masaryk 22.02.2021
SET var=%cd%


psexec \\%ipad% -c %cd%\Disable_Offline_Files.bat

PAUSE



