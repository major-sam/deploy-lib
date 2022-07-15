# TASK UNICOM-217
# https://jira.baltbet.ru:8443/browse/UNICOM-217


Import-module '.\scripts\sideFunctions.psm1'

$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"


$serviceName = "UnicomWebRegistration"
$targetDir = "C:\Services\UnicomWebRegistration\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$dbRegName = "UnicomWebRegistration"
$dbAdmName = "UniAdministration"


Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Настраиваем секцию подключения к БД
$jsonAppsetings.ConnectionStrings.RegistrationDataContext = "data source=localhost;initial catalog=${dbRegName};Integrated Security=true;MultipleActiveResultSets=True;"
$jsonAppsetings.ConnectionStrings.SettingsDataContext = "data source=localhost;initial catalog=${dbAdmName};Integrated Security=true;MultipleActiveResultSets=True;"

# Настраиваем подключение к Redis
$jsonAppsetings.ConnectionStrings.Redis = "$shortRedisStr,syncTimeout=1000,allowAdmin=True,connectTimeout=5000,ssl=False,abortConnect=False,connectRetry=10,proxy=None,configCheckSeconds=5"

# Настраиваем секцию логирования
<# $jsonAppsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\${serviceName}\${serviceName}-.txt" 
        $_.Args.restrictedToMinimumLevel = "Warning" 
    }
} #>

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"