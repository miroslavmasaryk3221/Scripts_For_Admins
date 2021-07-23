$null = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Smo')

    $ClusterInstances = @{}


    # try to get the instance and instance server name when SQL runs in a cluster
    $ClusterWMIdata = get-wmiobject -class "MSCluster_Resource" -namespace "root\mscluster"  -Authentication PacketPrivacy -ErrorAction SilentlyContinue
    
    if ($ClusterWMIdata){
    $ClusterWMIdata | where {$_.type -eq "SQL Server"} | % { $ClusterInstances[$_.PrivateProperties.InstanceName]=$_.PrivateProperties.VirtualServerName}
    } # end if clusterwmidata


    # fetch running SQL server services on localhost
    $services = Get-Service | Where-Object -FilterScript {
        $_.displayname -match '^SQL Server.\(' -and $_.status -eq 'running'
    }

    # determine the SQL instance network name

    if ($services -match '[A-Za-z0-9]') 
    {
        $services |  ForEach-Object -Process {
            $servicename = $_.name
            $dbs = $null
            $logins = $null
            $instancematch = $null
            $sql_instance = $null

            $InstanceName = $servicename

            if ($servicename.contains("$")) {
            $InstanceName = $ServiceName.split('$')[1]
            }

            # if service is a SQL instance then retrieve the full instance name
            if ($ClusterInstances) 
            { 
                $InstanceMatch = $ClusterInstances[$InstanceName]
            } # end if clusterinstances

            #  if the instance is running in a cluster then uses the cluster server name fetched from cluster wmi to connect
            #  otherwise connect to localhost instead
            if ($instancematch -and $instancename -eq 'MSSQLSERVER')
            {
                $sql_instance = $instancematch
            } elseif ( $instancematch)
            {
                $sql_instance = "$instancematch\$instancename"
            } elseif ( $servicename.contains("$"))
            {
                $sql_instance = "localhost\$instancename"
            } # end if networkinstances

            # fetch data from sql with pass-through windows authentication
$sql_instance

        } # end foreach service
    } # end if services