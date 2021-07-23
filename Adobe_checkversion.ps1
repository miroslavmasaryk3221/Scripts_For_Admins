
$Output = ForEach ($servers in Get-Content "C:\scripts\scriptsforadmin\servers.txt")
{

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


$list | where { $_.DisplayName -match 'Adobe'} | select ComputerName, DisplayName, DisplayVersion | FT

#checkmk/sql
$list=@()
$InstalledSoftwareKey="SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
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


$list | where { $_.DisplayName -match 'Adobe'} | select ComputerName, DisplayName, DisplayVersion | FT

Write-Output "------------------------------------------------------------------------------------------------------------------"

}

$Output | Out-File -FilePath C:\scripts\txt\ADOBE_PC_VERSION.txt