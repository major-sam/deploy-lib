Import-module '.\scripts\sideFunctions.psm1'

Write-host '[INFO] Start EventService deploy script'
#get release params

$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$defaultDomain = "bb-webapps.com"
$targetDir  = "C:\Services\EventService"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5


###
#Json values replace
####
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % {$_ -replace  '[\s^]//.*', ""} | ConvertFrom-Json 

$fileLogs = $jsonAppsetings.Serilog.WriteTo | where {$_.Name -eq 'File' }
$fileLogs.Args.path = "C:\Logs\Uni.EventService\Uni.EventService-.log"

# Настраиваем секцию сертификата
$jsonAppsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):44373"
$jsonAppsetings.Kestrel.Endpoints.Https.Certificate.Subject = "*.bb-webapps.com"

# Настраиваем коннект до редиса. Появился в задаче Web-6930
try{ $jsonAppsetings.ConnectionStrings.Redis = $shortRedisStr} 
catch { Write-Host -ForegroundColor Green "[INFO] Not found redis connection string in $($pathtojson)" }

# Меняем порт GrpcPort
$jsonAppsetings.GrpcSettings.KernelPrematchService.Port = "32418"

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"
