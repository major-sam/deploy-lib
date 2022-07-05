# PAY-786
# https://jira.baltbet.ru:8443/browse/PAY-786
# Реализовать деплой сервисов EraiService, EraiWebUI, EraiDb в Jenkins
# Биндинг порта зашит в коде - 8080
# Запускаем как сервис


Import-module '.\scripts\sideFunctions.psm1'

$serviceName = "EraiService"
$targetDir = "C:\Services\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5

$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr = "host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd;publisherConfirms=true;timeout=100;requestedHeartbeat=0"

# ERAI vars
$dbname = "EraiDB"
$eraiApiKey = $env:ERAI_API_KEY_TEST
$eraiCertThumbprint = $env:ERAI_THUMBPRINT_TEST
$eraiUrl = "https://api.demo.erai.ru"
$eraiOperatorId = "16"
# Default value for PeriodsSettings and EventCheckSettings - for TEST ENV ONLY
$defaultValue = 1
$eraiDbCS = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${dbname};Trust Server Certificate=true"

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Настраиваем EraiSettings
Write-host "[INFO] Change EraiSettings"
$jsonAppsetings.EraiSettings.ApiKey = $eraiApiKey
$jsonAppsetings.EraiSettings.CertificateThumbprint = $eraiCertThumbprint
$jsonAppsetings.EraiSettings.Url = $eraiUrl
$jsonAppsetings.EraiSettings.OperatorId = $eraiOperatorId

# Настраиваем секцию ConnectionStrings
Write-host "[INFO] Change settings for ConnectionStrings"
$jsonAppsetings.ConnectionStrings.RabbitMQ = $shortRabbitStr
$jsonAppsetings.ConnectionStrings.EraiDb = $eraiDbCS

# Настраиваем секцию логирования
$jsonAppsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\${serviceName}\${serviceName}-.log" 
    }
}

# Настраиваем секцию PeriodsSettings
Write-host "[INFO] Change settings for PeriodsSettings"
$jsonAppsetings.PeriodsSettings.DebetKrm = $defaultValue
$jsonAppsetings.PeriodsSettings.DepositKrm = $defaultValue
$jsonAppsetings.PeriodsSettings.DebetRuSite = $defaultValue
$jsonAppsetings.PeriodsSettings.DepositRuSite = $defaultValue
$jsonAppsetings.PeriodsSettings.DebetPps = $defaultValue
$jsonAppsetings.PeriodsSettings.DepositPps = $defaultValue
$jsonAppsetings.PeriodsSettings.EventLive = $defaultValue
$jsonAppsetings.PeriodsSettings.EventLine = $defaultValue
$jsonAppsetings.PeriodsSettings.Championships = $defaultValue
$jsonAppsetings.PeriodsSettings.PeriodicallySend = $defaultValue
$jsonAppsetings.PeriodsSettings.PeriodicallyUpdateStatus = $defaultValue
$jsonAppsetings.PeriodsSettings.SenderEnabled = $true

# Настраиваем секцию EventCheckSettings
Write-host "[INFO] Change settings for EventCheckSettings"
$jsonAppsetings.EventCheckSettings.LineMinutes = $defaultValue
$jsonAppsetings.EventCheckSettings.LiveMinutes = $defaultValue


ConvertTo-Json $jsonAppsetings -Depth $jsonDepth | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"