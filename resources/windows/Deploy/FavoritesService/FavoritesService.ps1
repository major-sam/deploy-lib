import-module '.\scripts\sideFunctions.psm1'
$FavoritesServiceAppsettings = "c:\Services\FavoritesService\appsettings.json"

$redispasswd = "$($ENV:REDIS_CREDS_PWD)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PWD)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$configFile = Get-Content -Raw -path $FavoritesServiceAppsettings -Encoding UTF8
$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*'  -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$json_appsetings.ConnectionStrings.Redis = $shortRedisStr
ConvertTo-Json $json_appsetings -Depth 5  | Format-Json | Set-Content $FavoritesServiceAppsettings -Encoding UTF8
