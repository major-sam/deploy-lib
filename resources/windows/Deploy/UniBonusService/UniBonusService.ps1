Import-module '.\scripts\sideFunctions.psm1'

$redispasswd = $ENV:REDIS_CREDS_PSW
$shortRedisStr="$($env:REDIS_HOST),password=$redispasswd"
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
$ServiceName = "UniBonusService"
$targetDir = "C:\Services\$($ServiceName)"
$pathtojson = "$targetDir\appsettings.json"
$wildcardDomain = "bb-webapps.com"
$uniRu_https_port = 4443
$KRM_https_port = 9081
$origins = @(
    "https://$($env:COMPUTERNAME).$($wildcardDomain):$($uniRu_https_port)".toLower()
    "https://$($env:COMPUTERNAME).$($wildcardDomain):$($KRM_https_port)".toLower()
)

Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$json_appsetings = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

$json_appsetings.Origins = $origins
try {
    $json_appsetings.ConnectionStrings.Redis = $shortRedisStr
} catch {
    Write-Host "[WARN] redis ConnectionStrings field not found..."
}
try {
    $json_appsetings.LegacyTokenAuthentication.DecryptionKey = $env:UniDecryptionKey
    $json_appsetings.LegacyTokenAuthentication.ValidationKey = $env:UniValidationKey
} catch {
    Write-Host "[WARN] LegacyTokenAuthentication field not found..."
}

$json_appsetings.GlobalLog.Rabbitmq_.DefaultConnectionString = "$shortRabbitStr; publisherConfirms=true; timeout=100; requestedHeartbeat=0"
ConvertTo-Json $json_appsetings -Depth 4 | Format-Json | Set-Content $pathtojson -Encoding UTF8
