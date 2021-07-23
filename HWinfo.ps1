function Get-HWinfo{

param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
        [string]$Computer
       
    )



process {
$computerSystem = gwmi Win32_ComputerSystem -ComputerName $Computer
$computerBIOS = gwmi Win32_BIOS -ComputerName $Computer
$computerOS = gwmi Win32_OperatingSystem -ComputerName $Computer
$computerCPU = gwmi Win32_Processor  -ComputerName $Computer | select -Property Name
$computerCores = gwmi Win32_ComputerSystem -ComputerName $Computer | select NumberOfProcessors, NumberOfLogicalProcessors

$HDD = Get-WmiObject -Class Win32_logicaldisk -ComputerName $Computer -Filter "DriveType = '3'" | select -Property DeviceID,
                        @{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}}

#write-Host "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
#"-------------------------------------------------------"
#"Manufacturer: " + $computerSystem.Manufacturer
#"Model: " + $computerSystem.Model

#"-------------------------------------------------------"
#"Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion

###"-------------------------------------------------------"
#"CPU: " + $computerCPU.Name
#"CPU Cores: "+$computerCores

#"-------------------------------------------------------"
#"RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"

#"-------------------------------------------------------"
#"HDD: "





            $obj = New-Object -TypeName PSObject -Property @{
               Computer=$computerSystem.Name
               Manufacturer=$computerSystem.Manufacturer
               Model= $computerSystem.Model
               System= $computerOS.caption 
               ServicePack = $computerOS.ServicePackMajorVersion
               CPU=$computerCPU
               CPUCores= $computerCores
               RAM=  $computerSystem.TotalPhysicalMemory/1GB
               CheckMK= $computerMKV
               HDD=$HDD
               
               }
                $objects += $obj;
                $objects | select  Computer, Manufacturer,     Model,   System , ServicePack, CPU , CPUCores , RAM
                
               $svTbl = @{}
                }


















}

$Output = ForEach ($servers in Get-Content "C:\scripts\scriptsforadmin\servers.txt")
{
#basic hw info
Get-HWinfo -Computer $servers  
# total hdd space
$totalSpc = 0
get-wmiobject -class win32_logicalDisk -ComputerName $servers | where-object {$_.driveType -eq 3 -and `
!($_.volumeName -eq $null)} | foreach-object {$totalSpc = $totalSpc + $_.size/1073741824}

Write-Output "Total Disk Space : $totalSPc"
#space HDD by disks
Get-WmiObject -Class Win32_logicaldisk -ComputerName $servers -Filter "DriveType = '3'" | select -Property DeviceID,
                        @{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}}


#checkmk/sql
$list=@()
$InstalledSoftwareKey="SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$InstalledSoftware=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$servers)
$RegistryKey=$InstalledSoftware.OpenSubKey($InstalledSoftwareKey) 
$SubKeys=$RegistryKey.GetSubKeyNames()
Foreach ($key in $SubKeys){
$thisKey=$InstalledSoftwareKey+"\\"+$key
$thisSubKey=$InstalledSoftware.OpenSubKey($thisKey)
$obj = New-Object PSObject
$obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $Servers
$obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName"))
$obj | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion"))
$list += $obj
}

$list | where { $_.DisplayName -eq "Check_MK Agent"} | select ComputerName, DisplayName, DisplayVersion | FT
$list | where { $_.DisplayName -match 'Microsoft SQL'} | select ComputerName, DisplayName, DisplayVersion | FT

Write-Output "------------------------------------------------------------------------------------------------------------------"

}

$Output | Out-File -FilePath C:\scripts\report_servers1.txt 