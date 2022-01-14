$PathToConfig = "C:\Kernel\Kernel.exe.config"

[xml]$config = Get-Content -Path $PathToConfig 
$DefaultParser = $config.configuration.'system.serviceModel'.client.endpoint | Where-Object name -eq "Default"
$DefaultParser.address = "http://$($env:COMPUTERNAME):9011/"

$ExperimentalParser = $config.configuration.'system.serviceModel'.client.endpoint | Where-Object name -eq "Experimental"
$ExperimentalParser.address = "http://$($env:COMPUTERNAME):9012/"

$Bet365Parser = $config.configuration.'system.serviceModel'.client.endpoint | Where-Object name -eq "Bet365"
$Bet365Parser.address = "http://$($env:COMPUTERNAME):9013/"

$config.Save($PathToConfig)
