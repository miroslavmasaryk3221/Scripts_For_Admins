#Initialization
$Share = Read-Host -Prompt 'Input the share name '
$Share_r = "$Share" + '_r'
$Share_w = "$Share" + '_w' 
$Server = Read-Host -Prompt 'Input the server name '
#DEOTIS PART
$Server1 = 'deotis\datadl_' + $Server + '_' + $Share_r + ':RX Administrators:RX Protect'
$Server2 = 'deotis\datadl_' + $Server + '_' + $Share_w + ':RX Administrators:RX Protect'
#OT PART
$Serverot = 'ot\deotis_datadl_' + $Server + '_' + $Share_r + ':RX Administrators:RX Protect'
$Serverot1 = 'ot\deotis_datadl_' + $Server + '_' + $Share_w + ':RX Administrators:RX Protect'
#Final
$Shareserverdeot =     'dfsutil property sd grant' + ' ' + '\\deotis\myfileservices\' + $Share + ' ' + $Server1 
$Shareserverdeot1 =    'dfsutil property sd grant' + ' ' + '\\deotis\myfileservices\' + $Share + ' ' + $Server2
$Shareserverot =       'dfsutil property sd grant' + ' ' + '\\deotis\myfileservices\' + $Share + ' ' + $Serverot
$Shareserverot1 =      'dfsutil property sd grant' + ' ' + '\\deotis\myfileservices\' + $Share + ' ' + $Serverot1

#Run

$Check= 'dfsutil property sd \\deotis\myfileservices\' + $Share

$Check1= 'dfsutil property sd \\ot\deotis\myfileservices\' + $Share


Invoke-Expression $ShareServerdeot

Invoke-Expression $ShareServerdeot1

Invoke-Expression $ShareServerot

Invoke-Expression $ShareServerot1

Invoke-Expression $Check


Invoke-Expression $Check1
