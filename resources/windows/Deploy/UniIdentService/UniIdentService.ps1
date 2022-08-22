Import-module '.\scripts\sideFunctions.psm1'
$ServiceName = "UniIdentService"
$targetDir = "C:\inetpub\$($ServiceName)"
$pathtojson = "$targetDir\appsettings.json"

$redispasswd = $ENV:REDIS_CREDS_PSW
$shortRedisStr="$($env:REDIS_HOST),password=$redispasswd"
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$json_appsetings = Get-Content -Raw -path $pathtojson | ConvertFrom-Json 

$json_appsetings.ConnectionStrings.UniSiteSettings = "data source=$($env:COMPUTERNAME);initial catalog=UniRu;Integrated Security=SSPI;MultipleActiveResultSets=True;"
$json_appsetings.LegacyTokenAuthentication.DecryptionKey = $env:UniDecryptionKey
$json_appsetings.LegacyTokenAuthentication.ValidationKey = $env:UniValidationKey
$json_appsetings.ConnectionStrings.Redis = $shortRedisStr
$json_appsetings.GlobalLog.Rabbitmq_.DefaultConnectionString = "$shortRabbitStr ;publisherConfirms=true; timeout=100; requestedHeartbeat=0"
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8
