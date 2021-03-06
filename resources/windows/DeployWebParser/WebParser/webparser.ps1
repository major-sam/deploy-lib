import-module '.\scripts\sideFunctions.psm1'

$ServicesFolder = "C:\Services"
$ServiceName = "WebParser"
$PathToConfig = "$($ServicesFolder)\$($ServiceName)\Config"
$PathToExeConfig = "$($ServicesFolder)\$($ServiceName)\WebParser.exe.config"
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

Write-Host "[INFO] EDIT WebParser.exe.config..."
[xml]$config = Get-Content -Path $PathToExeConfig
$ServiceWebParser = $config.configuration.'system.serviceModel'.services.service | Where-Object name -eq "WebParser.ServiceWebParser"
$ServiceWebParser.endpoint.address = "http://$($env:COMPUTERNAME):9011"

$BaseParserContext = $config.configuration.connectionStrings.add | Where-Object name -eq "Parser.Base.Line.ParserContext"
$BaseParserContext.connectionString = "data source=$($env:COMPUTERNAME);Integrated Security=SSPI;initial catalog=Parser;MultipleActiveResultSets=True;"

$RabbitConnection = $config.configuration.connectionStrings.add | Where-Object name -eq "RabbitConnection"
$RabbitConnection.connectionString = "$shortRabbitStr; publisherConfirms=true; timeout=100; requestedHeartbeat=0"

$RabbitClientAPK = $config.configuration.connectionStrings.add | Where-Object name -eq "RabbitClientAPK"
$RabbitClientAPK.connectionString = "$shortRabbitStr; publisherConfirms=true; timeout=100; requestedHeartbeat=0"

$config.Save($PathToExeConfig)

Write-Host "[INFO] EDIT Settings.xml..."
[xml]$config = Get-Content -Path "$($PathToConfig)\Settings.xml"
$config.Settings.GrpcHost = $env:COMPUTERNAME
$config.Save("$($PathToConfig)\Settings.xml")
