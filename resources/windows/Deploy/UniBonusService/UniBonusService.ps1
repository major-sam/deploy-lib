Import-module '.\scripts\sideFunctions.psm1'

$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
$ServiceName = "UniBonusService"
$targetDir = "C:\Services\$($ServiceName)"
$pathtojson = "$targetDir\appsettings.json"
$uniRu_https_port = 4443
$origins = @(
    "https://${env:COMPUTERNAME}.bb-webapps.com:${uniRu_https_port}"
)

Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$json_appsetings = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

$json_appsetings.Origins = $origins
try {
    $json_appsetings.LegacyTokenAuthentication.DecryptionKey = $env:UniDecryptionKey
    $json_appsetings.LegacyTokenAuthentication.ValidationKey = $env:UniValidationKey
} catch {
    Write-Host "[WARN] LegacyTokenAuthentication field not found..."
}

$json_appsetings.GlobalLog.Rabbitmq_.DefaultConnectionString = "$shortRabbitStr; publisherConfirms=true; timeout=100; requestedHeartbeat=0"
ConvertTo-Json $json_appsetings -Depth 4 | Format-Json | Set-Content $pathtojson -Encoding UTF8
