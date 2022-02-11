Import-module '.\scripts\sideFunctions.psm1'


$serviceName = "BaltBet.AccountStatisticsService.Host"
$targetDir = "C:\Services\AccountStatisticsService\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$cupisHostPort = 4453
$defaultDomain = "bb-webapps.com"

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

# Настраиваем секцию подключения к БД
$jsonAppsetings.ConnectionStrings.AccountStatisticsServiceDb = "data source=localhost;initial catalog=AccountStatisticsService;Integrated Security=true;MultipleActiveResultSets=True;"

# Меняем порт GrpcPort
$jsonAppsetings.CupisIntegrationService.BaseUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):${cupisHostPort}/"

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"