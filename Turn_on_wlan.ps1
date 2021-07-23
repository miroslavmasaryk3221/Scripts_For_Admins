

#Declaration
$Computer= Read-Host -Prompt "Enter PC Name"
$cred= Get-Credential -Message "Enter your TA Account" 

$Get_Status= Invoke-Command -Computer $Computer -Credential $cred -Scriptblock {Get-NetAdapter | Where status -ne up }

#Enable PS Remoting temporarily/On Next windows start it will be disabled
#Start-Process "cmd.exe"  "/c .\Enable-remoting.bat" -Wait
cls
Invoke-Command -Computer $Computer -Credential $cred -Scriptblock {Get-NetAdapter | Where status -ne up }
#Process for enabling

$Determine= Read-Host -Prompt " 
                     
                     Enter 1 for enable 2 for exit
 
 
 
 "                    
    
    if ($Determine -eq '1') { 
                           Invoke-Command -Computer $Computer -Credential $cred -Scriptblock {Get-NetAdapter |Where status -ne up | Enable-NetAdapter }
                           Invoke-Command -Computer $Computer -Credential $cred -Scriptblock {Get-NetAdapter | Where status -ne up }
                        
                           }
                           else { exit }