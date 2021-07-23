@echo off

set /p userpc=Enter PC Name: 

echo %userpc%

	
PsExec.exe \\%userpc% sc config remoteregistry start=auto
	
PsExec.exe \\%userpc% sc start remoteregistry