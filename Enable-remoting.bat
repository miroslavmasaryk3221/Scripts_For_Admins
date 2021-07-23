@echo off
set /p id="Enter IP or Name: "
psexec \\%id%  cmd.exe /c "powershell -Command Enable-PSRemoting -SkipNetworkProfileCheck -Force"
 

PAUSE

