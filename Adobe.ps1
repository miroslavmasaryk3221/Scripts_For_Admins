# Silent install Adobe Reader DC
# https://get.adobe.com/nl/reader/enterprise/

# Path for the workdir




#[string]$sourceDirectory  = "C:\installer\Adobe*"
#[string]$destinationDirectory = "\\odefmd06\c$\installer"
#Copy-item -Force -Recurse -Verbose $sourceDirectory -Destination $destinationDirectory



Invoke-Command -Computername "entername" -ScriptBlock { 
AcroRdrDC2100120140_de_DE.exe /sAll /rs /msi EULA_ACCEPT=YES}

# Wait XX Seconds for the installation to finish
#
Start-Sleep -s 60

# Remove the installer

