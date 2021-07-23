
$Servicename = 'winmgmt'

function StopOrProceed{
 <#
        .Info
           Script  will enable PS remoting through psexec  than stop the winmgmt process and reset the wmi repository in order to fix stucked Client
        .PARAMETER
            NoParam
            Miroslav Masaryk
         
   #>
 
 $arrService = Get-Service -Name $ServiceName -ComputerName $Name
 
 
    if ($arrService.Status -eq "Running"){
 
    Write-Host "Service is running, trying again" 

 " ---------------------- " 
 
                                        }
    if ($arrService.Status -eq "Stopped"){ 
    cls
    Write-Host "$ServiceName Service is stopped, proceeding with next steps"
    Write-Host " 
 
                    Resetting WMI REPOSITORY
 
                                              "
 Invoke-Command -ComputerName $Name -credential $cred -ScriptBlock { $a = winmgmt /resetrepository ; 
return $a}

 
 
                                         }
                        }
 
 


 cls

Write-Host 
"====================================SoftwareCenter_stuck_fix======================================+
                                                                                                  +
                                                                                                  +
                                                                                                  +
                                                                                                  +
    Script enable PS remoting than stop the winmgmt process and reset the wmi repository          +
                                                                                                  +
                                                                                                  +
                                                                                                  +
                    Script made by Miroslav Masaryk                                               +
                                                                                                  +
                                                                                                  +
==================================================================================================+
"

$Name = Read-Host -Prompt 'Input the PC name/IP '

$cred=Get-Credential


Start-Process "cmd.exe"  "/c .\Enable-remoting.bat" -Wait

Set-Item wsman:\localhost\Client\TrustedHosts -value $Name  -Force 




Invoke-Command -ComputerName $Name -credential $cred -ScriptBlock { $a = net stop winmgmt /y ;
return $a}

Start-Sleep -s 1

Invoke-Command -ComputerName $Name -credential $cred -ScriptBlock { net stop winmgmt /y ;}

Start-Sleep -s 2

StopOrProceed




 Start-Process "cmd.exe"  "/c .\SCCM_RESET_part2.bat" -Wait