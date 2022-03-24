<#
ARCHI-225
https://jira.baltbet.ru:8443/browse/ARCHI-225

UniAuthServiceGrpc (запускаем как windows сервис)
#>

Import-module '.\scripts\sideFunctions.psm1'


$serviceName = "UniAuthServiceGrpc"
$targetDir = "C:\Services\UniAuthService\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$uasGrpcPort = 5037
$dbname = "AuthService"

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

# Настраиваем секцию подключения к БД
$jsonAppsetings.ConnectionStrings.AuthDb = "data source=localhost;initial catalog=${dbname};Integrated Security=SSPI;MultipleActiveResultSets=True;"

# Меняем порт GrpcPort
$jsonAppsetings.Kestrel.Endpoints.Grpc.Url = "http://0.0.0.0:${uasGrpcPort}"

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"