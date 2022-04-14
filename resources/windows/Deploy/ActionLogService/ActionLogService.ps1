Import-module '.\scripts\sideFunctions.psm1'
$redispasswd = "$($ENV:REDIS_CREDS_PWD)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PWD)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
$ServiceName = "ActionLogService"
$ServiceFolderPath = "C:\Services\${ServiceName}"
$Catalog = "BaltBetM"


Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.ActionLogService configuration files..."
$config = Get-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$config.Serilog.WriteTo[1].Args.path = "C:\logs\ActionLogService\ActionLogService-.log"
$config.Settings.RabbitMq = "$shortRabbitStr;publisherConfirms=true; timeout=100; requestedHeartbeat=0"
$config.Settings.Database = "data source=localhost;initial catalog=${Catalog};Integrated Security=true;MultipleActiveResultSets=True;"

ConvertTo-Json $config -Depth 5  | Format-Json | Set-Content "$ServiceFolderPath\appsettings.json" -Encoding UTF8
