import-module '.\scripts\sideFunctions.psm1'
Import-Module Carbon

$ServicesFolder = "C:\Services"
$ServiceName = "WebParser"
$PathToConfig = "$($ServicesFolder)\$($ServiceName)\Config"
$PathToExeConfig = "$($ServicesFolder)\$($ServiceName)\WebParser.exe.config"

Write-Host "[INFO] EDIT WebParser.exe.config..."
[xml]$config = Get-Content -Path $PathToExeConfig
$ServiceWebParser = $config.configuration.'system.serviceModel'.services.service | Where-Object name -eq "WebParser.ServiceWebParser"
$ServiceWebParser.endpoint.address = "http://$($env:COMPUTERNAME):19020"

$BaseParserContext = $config.configuration.connectionStrings.add | Where-Object name -eq "Parser.Base.Line.ParserContext"
$BaseParserContext.connectionString = "data source=$($env:COMPUTERNAME);Integrated Security=SSPI;initial catalog=$($ServiceName);MultipleActiveResultSets=True;"

$RabbitConnection = $config.configuration.connectionStrings.add | Where-Object name -eq "RabbitConnection"
$RabbitConnection.connectionString = "host=$($env:COMPUTERNAME):5672; username=test; password=test; publisherConfirms=true; timeout=100; requestedHeartbeat=0"

$RabbitClientAPK = $config.configuration.connectionStrings.add | Where-Object name -eq "RabbitClientAPK"
$RabbitClientAPK.connectionString = "host=$($env:COMPUTERNAME):5672; username=test; password=test; publisherConfirms=true; timeout=100; requestedHeartbeat=0"

$config.Save($PathToExeConfig)


Write-Host "[INFO] Run XML Transformation"
Convert-XmlFile -Path "$PathToConfig\Settings.xml" -XdtPath "$PathToConfig\Settings.Test.xml" -Destination "$PathToConfig\SettingsNew.xml"
Remove-Item "$PathToConfig\Settings.xml"
Move-Item "$PathToConfig\SettingsNew.xml" "$PathToConfig\Settings.xml"

Write-Host "[INFO] EDIT Settings.xml..."
[xml]$config = Get-Content -Path "$($PathToConfig)\Settings.xml"
$config.Settings.GrpcHost = $env:COMPUTERNAME
$config.Save("$($PathToConfig)\Settings.xml")
