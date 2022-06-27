Import-module '.\scripts\sideFunctions.psm1'

$serviceName = "Service"
$targetDir = "C:\Services\Payments\Antifraud\${ServiceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5

$dbname = "Antifraud"
$AggregatorDb = "BaltBet_Payment_Test"
$AggregatorDbServer = "TEST-SQL16WIN19\MSSQLSERVER2"
$httpsAFServicePort = 7157
$defaultDomain = "bb-webapps.com"


Write-host "[INFO] Start Antifraud${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Настраиваем секцию логирования
$jsonAppsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\Payments\Antifraud\Antifraud.Service-.log"
    }
}

# Настраиваем секцию сертификата
$jsonAppsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):$httpsAFServicePort"
$jsonAppsetings.Kestrel.Endpoints.Https.Certificate.Subject = "*.bb-webapps.com"

# Настраиваем секцию подключения к БД
$jsonAppsetings.ConnectionStrings.Db = "data source=localhost;initial catalog=${dbname};Integrated Security=true;MultipleActiveResultSets=True;"
$jsonAppsetings.ConnectionStrings.AggregatorDb = "data source=${AggregatorDbServer};initial catalog=${AggregatorDb};Integrated Security=true;MultipleActiveResultSets=True;"


ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"