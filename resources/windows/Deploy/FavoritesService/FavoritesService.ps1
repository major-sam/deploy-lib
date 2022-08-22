import-module '.\scripts\sideFunctions.psm1'
$FavoritesServiceAppsettings = "c:\Services\FavoritesService\appsettings.json"

$redispasswd = $ENV:REDIS_CREDS_PSW
$shortRedisStr="$($env:REDIS_HOST),password=$redispasswd"
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$configFile = Get-Content -Raw -path $FavoritesServiceAppsettings -Encoding UTF8
$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*'  -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$json_appsetings.ConnectionStrings.Redis = $shortRedisStr
ConvertTo-Json $json_appsetings -Depth 5  | Format-Json | Set-Content $FavoritesServiceAppsettings -Encoding UTF8
