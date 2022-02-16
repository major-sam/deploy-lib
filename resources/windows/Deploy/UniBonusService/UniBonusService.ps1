$ServiceName = "UniBonusService"
$targetDir = "C:\Services\$($ServiceName)"
$pathtojson = "$targetDir\appsettings.json"

Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$json_appsetings = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

$json_appsetings.LegacyTokenAuthentication.DecryptionKey = $env:UniDecryptionKey
$json_appsetings.LegacyTokenAuthentication.ValidationKey = $env:UniValidationKey
$json_appsetings.GlobalLog.Rabbitmq_.DefaultConnectionString = "host=$($env:COMPUTERNAME):5672; username=test; password=test; publisherConfirms=true; timeout=100; requestedHeartbeat=0"
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8
