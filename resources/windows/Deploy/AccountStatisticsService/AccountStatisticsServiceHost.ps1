Import-module '.\scripts\sideFunctions.psm1'


$serviceName = "BaltBet.AccountStatisticsService.Host"
$targetDir = "C:\Services\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$cupisHostPort = 4453
$assHttpsPort = 4436
$assGrpcPort = 5038
$defaultDomain = "bb-webapps.com"

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

# Настраиваем секцию подключения к БД
$jsonAppsetings.ConnectionStrings.AccountStatisticsServiceDb = "data source=localhost;initial catalog=AccountStatisticsService;Integrated Security=true;MultipleActiveResultSets=True;"

# Настраиваем секцию подключения к CIS
$jsonAppsetings.CupisIntegrationService.BaseUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):${cupisHostPort}/"

# Настраиваем секцию Kestrel.Https
$jsonAppsetings.Kestrel.EndPoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${assHttpsPort}"
$jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Location = "LocalMachine"
$jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Subject = "*.bb-webapps.com"
$jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Store = "My"
$jsonAppsetings.Kestrel.EndPoints.Https.Certificate.AllowInvalid = "true"

# Настраиваем секцию Kestrel.GrpcPort
$jsonAppsetings.Kestrel.EndPoints.gRPC.Url = "http://localhost:${assGrpcPort}"


ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"