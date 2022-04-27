Import-module '.\scripts\sideFunctions.psm1'


$serviceName = "BaltBet.AccountStatisticsService.GrpcHost"
$targetDir = "C:\Services\AccountStatisticsService\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$assGrpcPort = 5038

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
if (test-path $pathtojson){
    $jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

# Настраиваем секцию подключения к БД
    $jsonAppsetings.ConnectionStrings.AccountStatisticsServiceDb = "data source=localhost;initial catalog=AccountStatisticsService;Integrated Security=true;MultipleActiveResultSets=True;"

# Меняем порт GrpcPort
    $jsonAppsetings.Kestrel.EndPoints.Https.Url = "http://localhost:${assGrpcPort}"

    ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
    Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"
}
else{
    Write-Host -ForegroundColor Green "[INFO] $pathtojson not exists"
}
