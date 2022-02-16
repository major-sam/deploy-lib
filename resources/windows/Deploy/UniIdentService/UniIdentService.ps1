$ServiceName = "UniIdentService"
$targetDir = "C:\inetpub\$($ServiceName)"
$pathtojson = "$targetDir\appsettings.json"
$json_appsetings = Get-Content -Raw -path $pathtojson | ConvertFrom-Json 

$json_appsetings.ConnectionStrings.UniSiteSettings = "data source=$($env:COMPUTERNAME);initial catalog=UniRu;Integrated Security=SSPI;MultipleActiveResultSets=True;"
$json_appsetings.LegacyTokenAuthentication.DecryptionKey = $env:UniDecryptionKey
$json_appsetings.LegacyTokenAuthentication.ValidationKey = $env:UniValidationKey
$json_appsetings.GlobalLog.Rabbitmq_.DefaultConnectionString = "host=$($env:COMPUTERNAME):5672; username=test; password=test; publisherConfirms=true; timeout=100; requestedHeartbeat=0"
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8
