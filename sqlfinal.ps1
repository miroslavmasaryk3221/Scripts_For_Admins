

function Get-DatabaseSize{
 <#
        .Info
           Script  will get Info of dbs and logs from sqlservers defined in file
        .PARAMETER
           -IncludeSystemDBs 
  Miroslav Masaryk 25.02.2021
         
   #>
 

 
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
        [string]$serverInstance,
        [Parameter(Mandatory=$false,Position=1,ValueFromPipeline=$false)]
        [switch]$IncludeSystemDBs
    )
    begin{
        $objects = @();
        $srvConn = New-Object microsoft.SqlServer.Management.Common.ServerConnection
        $srvConn.LoginSecure = $true;
        $srvConn.ServerInstance = $serverInstance
        $server = New-Object microsoft.SqlServer.Management.Smo.Server $srvConn
    }
    process {
        foreach($db in $server.Databases | where{$_.IsSystemObject -eq $IncludeSystemDBs -or -not $_.IsSystemObject}){

        Switch ($db.IsAccessible) {
    "True" {$dbstatus = "Online"}
    "False" {$dbstatus = "Offline"}
    }
                
               
            
            
            $logSize = 0;
            $UsedLogSpace = 0;
            foreach($log in $db.LogFiles ){
                $logSize += $log.Size
                $UsedLogSpace += $log.UsedSpace
                
            } 
            $obj = New-Object -TypeName PSObject -Property @{
                ServerInstance = $serverInstance
                DatabaseName = $db.Name
                DBSize= [Math]::Round($db.size,1) 
                DataSpaceUsageKB = $db.DataSpaceUsage 
                IndexSpaceUsageKB = $db.IndexSpaceUsage
                UsedLogSpaceKB = $UsedLogSpace
                LogSizeKB = $logSize
                Status = $dbstatus
            } 
            $objects += $obj;
        
         
        
        }

       
        
       
       
        $objects | SELECT ServerInstance,     DatabaseName,   DBSize , LogSizeKB, Status 
    }
    end{
        $srvConn.Disconnect();
    }
}
    
import-module sqlserver
$Output = ForEach ($instance in Get-Content "C:\scripts\scriptsforadmin\instances.txt")
{

       
Get-DatabaseSize -serverInstance "$instance" -IncludeSystemDBs |  Format-Table `
@{Name='ServerInstance';Expression={$_.ServerInstance};align='left';width=14},
@{Name='DatabaseName';Expression={$_.DatabaseName};align='left'},
@{Name='DBSizeMB';Expression={$_.DBSize};align='right'},
@{Name='DBSizeGB'; Expression={[math]::round($_.DBSize/1000, 4)};align='right'},
@{Name='LogSizeMB';Expression={[math]::round($_.LogSizeKB/1000, 1)};align='right'},
@{Name='Status';Expression={$_.Status};align='right'} `
 
   
  


}

$Output | Out-File -FilePath C:\scripts\scriptsforadmin\report2.txt


 
       `
        `
    





