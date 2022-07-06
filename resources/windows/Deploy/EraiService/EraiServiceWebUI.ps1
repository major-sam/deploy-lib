# PAY-786
# https://jira.baltbet.ru:8443/browse/PAY-786
# Реализовать деплой сервисов EraiService, EraiWebUI, EraiDb в Jenkins
# Запускаем как сервис


Import-module '.\scripts\sideFunctions.psm1'

$serviceName = "EraiService.WebUI"
$targetDir = "C:\Services\ERAI\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5

$defaultDomain = "bb-webapps.com"

# ERAI vars
$dbname = "EraiDB"
$eraiApiKey = $env:ERAI_API_KEY_TEST
$eraiCertThumbprint = $env:ERAI_THUMBPRINT_TEST
$eraiUrl = "https://api.demo.erai.ru"
$eraiOperatorId = "16"
$eraiDbCS = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${dbname};Trust Server Certificate=true"
$eraiWebUiPort = 5018

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Настраиваем секцию ConnectionStrings
Write-host "[INFO] Change settings for ConnectionStrings"
$jsonAppsetings.ConnectionStrings.EraiDb = $eraiDbCS

# Настраиваем EraiSettings
Write-host "[INFO] Change EraiSettings"
$jsonAppsetings.EraiSettings.ApiKey = $eraiApiKey
$jsonAppsetings.EraiSettings.CertificateThumbprint = $eraiCertThumbprint
$jsonAppsetings.EraiSettings.Url = $eraiUrl
$jsonAppsetings.EraiSettings.OperatorId = $eraiOperatorId

# Настраиваем секцию логирования
$jsonAppsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\${serviceName}\${serviceName}-.log" 
    }
}

# Секция Kestrel добавлена в релизную ветку release/2022-07-07-02
if ($jsonAppsetings.Kestrel) {
    $jsonAppsetings.Kestrel.EndPoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${eraiWebUiPort}".ToLower()
    $jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Location = "LocalMachine"
    $jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Subject = "*.bb-webapps.com"
    $jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Store = "My"
    $jsonAppsetings.Kestrel.EndPoints.Https.Certificate.AllowInvalid = "true"
} else {
    Write-host "[INFO] Kestrel section does not exist"
}

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"