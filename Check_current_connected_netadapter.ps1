cls
#Declaration
$Computer= Read-Host -Prompt "Enter PC Name"
 

Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$Computer"
#Enable PS Remoting temporarily/On Next windows start it will be disabled
#Start-Process "cmd.exe"  "/c .\Enable-remoting.bat" -Wait



cls
Invoke-Command -Computer $Computer -Credential $cred -Scriptblock {Get-NetAdapter | Format-Table }
Read-Host -Prompt "Press Enter to exit"
