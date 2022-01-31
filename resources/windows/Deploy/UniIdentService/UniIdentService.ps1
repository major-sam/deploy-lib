$ServiceName = "UniIdentService"
$targetDir = "C:\inetpub\$($ServiceName)"
$pathtojson = "$targetDir\appsettings.json"
$json_appsetings = Get-Content -Raw -path $pathtojson | ConvertFrom-Json 

$json_appsetings.ConnectionStrings.UniSiteSettings = "data source=$($env:COMPUTERNAME);initial catalog=UniRu;Integrated Security=SSPI;MultipleActiveResultSets=True;"
$json_appsetings.LegacyTokenAuthentication.DecryptionKey = "17864EA0339933404215381FCB4E643B7AAE37C0EBD54466"
$json_appsetings.LegacyTokenAuthentication.ValidationKey = "9EE1C3992956A04B8C433CE488B30603A95EA98A2E208432263FF7D3F63E231F52761D17F8BC877DDE6BDA4505DF16313C1EFFAF3377D519A26F4BB31B98018B"
$json_appsetings.GlobalLog.Rabbitmq_.DefaultConnectionString = "host=$($env:COMPUTERNAME):5672; username=test; password=test; publisherConfirms=true; timeout=100; requestedHeartbeat=0"
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8