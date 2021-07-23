#Initialization
$Share = Read-Host -Prompt 'Input the share name '
$Share_r = "$Share" + '_r'
$Share_w = "$Share" + '_w' 
$Server = Read-Host -Prompt 'Input the server name '

#OT PART
$Serverot = 'OT\DEOTIS_DATADL_' + $Server + '_' + $Share_r + ':RX Administrators:RX Protect'
$Serverot1 = 'OT\DEOTIS_DATADL_' + $Server + '_' + $Share_w + ':RX Administrators:RX Protect'
#Final

$Shareserverot =       'dfsutil property sd grant' + ' ' + '\\ot\de-myfileservices\' + $Share + ' ' + $Serverot
$Shareserverot1 =      'dfsutil property sd grant' + ' ' + '\\ot\de-myfileservices\' + $Share + ' ' + $Serverot1

#Run

$Check= 'dfsutil property sd \\ot\de-myfileservices\' + $Share





Invoke-Expression $ShareServerot

Invoke-Expression $ShareServerot1

Invoke-Expression $Check



