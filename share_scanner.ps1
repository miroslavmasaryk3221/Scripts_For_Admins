#region variables
#$WorkingDirectory = $PSScriptRoot + "\"
#$OutputFolder = $WorkingDirectory + "Ausgabe\"
$OutputFolder = "\\odefmf02\ISCtrls\Monitoring\Shares\"

$TimeStamp = get-date -uformat '%d-%m-%Y'
$ServerName = $env:computername
#endregion variables



#region Functions
Function Get-ShareGroups($shares)
{
	$arrShareDetails = @()
	Foreach ($share in $shares)
	{
		try
		{
			# hole alle Rechtegruppen zu diesem Ordner die die where-kriterien erfüllen
			$ACLs = get-acl $share.Path |
			ForEach-Object {
				$_.Access
			} |
			Where-Object{
				$_.IdentityReference -ne 'builtin\users' -and $_.IdentityReference -ne "NT AUTHORITY\SYSTEM" -and $_.IdentityReference -ne "BUILTIN\Administrators" -and $_.IdentityReference -ne "creator owner" -and $_.IdentityReference -ne "NT Authority\*" -and $_.IdentityReference -ne "NT-AUTORITÄT\SYSTEM" -and $_.IdentityReference -ne "VORDEFINIERT\Administratoren" -and $_.IdentityReference -ne "VORDEFINIERT\Benutzer" -and $_.IdentityReference -ne "ERSTELLER-BESITZER"
			}
			
			# durchlaufe alle Rechtegruppen
			foreach ($ACL in $ACLs)
			{
				
				try
				{
					if (-not ([string]$ACL.IdentityReference).Equals("") -and -not ([string]$ACL.IdentityReference).Contains("S-1") -and -not ([string]$ACL.IdentityReference).Equals("Everyone"))
					{
						# filesystemrights übersetzen
						switch ($ACL.filesystemrights)
						{
							"ReadAndExecute, Synchronize" {
								$AccessRight = "lesend"
							}
							"Modify, Synchronize" {
								$AccessRight = "schreibend"
							}
							default {
								$AccessRight = $ACL.filesystemrights
							}
						}
						
						#erstelle neues Objekt
						$shareDetail = New-Object PSObject -Property @{
							'ServerName' = $ServerName;
							'ShareName'  = $share.Name;
							'IdentityReference' = ([String]$ACL.IdentityReference).split('\', [System.StringSplitOptions]::RemoveEmptyEntries)[1].trim();
							'Directory'  = $share.Path;
							'FileSystemRights' = $AccessRight;
							'ShareDescription' = $share.Description
						}
						
						$arrShareDetails += $shareDetail
					}
				}
				catch { }
			}
		}
		catch
		{
			$ProblemShares.Add($share.name, "failed to find user info")
			Write-Host "fehler in Get-ShareGroups für Share: $share"
			Write-Host $_
			Write-Host $_.Exception
			Write-Host $_.ErrorDetails
			Write-Host $_.ScriptStackTrace
		}
	}
	return $arrShareDetails
}
#endregion Functions

#Store shares where security cant be found in this hash table
$problemShares = @{
}

Write-Host "Suche Shares"

# get Shares (Type 0 is "Normal" shares) # can filter on path, etc. with where
$shares = Get-WmiObject Win32_Share -filter 'type=0' #| Where-Object {-not $_.path.substring(0,2) -eq "C:\"}

# get the security info from shares, add the objects to an array
Write-Host "Fertig" -ForegroundColor green
Write-Host "Bereite die Informationen für Export auf"

#Write-Host "Hole Share-Infos"
#$ShareInfo = Get-ShareInfo($shares)

Write-Host "Hole Share-Gruppen"
$ShareGroups = Get-ShareGroups($shares)

Write-Host "Complete" -ForegroundColor green

Write-Host "Exporting to CSV to $OutputFolder"

# Export them to CSV
$ShareGroups | export-csv -NoTypeInformation $OutputFolder"groups_"$ServerName"_"$TimeStamp".csv" -Force
#$shares | export-csv -NoTypeInformation $OutputFolder"shares_"$ServerName"_"$TimeStamp".csv" -Force

Write-Host "Complete" -ForegroundColor green
Write-Host "Your file has been saved to $OutputFolder"
Write-Host ""

If ($problemShares.count -ge 1)
{
	Write-Host "Some Shares failed." -ForegroundColor red
	$problemShares | export-csv -NoTypeInformation $OutputFolder"error_"$ServerName"_"$TimeStamp".csv" -Force
}
