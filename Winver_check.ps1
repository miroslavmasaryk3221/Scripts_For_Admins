$Name = Read-Host -Prompt 'Input the PC name/IP '

REG QUERY "\\$Name\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName
REG QUERY "\\$Name\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseID
REG QUERY "\\$Name\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild



