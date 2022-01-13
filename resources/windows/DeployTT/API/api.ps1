import-module '.\scripts\sideFunctions.psm1'
##### edit api json files
## mayby to env
$apiAddr =  (Get-NetIPAddress -AddressFamily IPv4 | ?{$_.InterfaceIndex -ne 1}).IPAddress
$apiPort = '50005'
$pathtojson = 'C:\Services\TradingTool\Services\Baltbet.TradingTool.Api\appsettings.json'
$jsonDepth = 4
$logPath = "C:\\Logs\\TradingTool\\Baltbet.TradingTool.Api.txt"

Write-Host -ForegroundColor Green "[info] edit json files"
$configFile = Get-Content -Raw -path $pathtojson 
## Json comment imporvement

$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'| ConvertFrom-Json

$json_appsetings.Kestrel.EndPoints.Http.Url =  "http://$($apiAddr):$($apiPort)"
$json_appsetings.AdfsOptions.Authenticate = "true"
$json_appsetings.AdfsOptions.Issuer = "http://adfs-next.gkbaltbet.local/adfs/services/trust"
($json_appsetings.Serilog.WriteTo | Where-Object {$_.Name -like 'File' }).Args.path = $logPath
$json_appsetings.AdfsOptions.Audience = "http://localhost:50005/"
$json_appsetings.ConnectionStrings.TradingToolDb =  "Data Source=localhost;Initial Catalog=TradingTool;Integrated Security=True"
## mayby to Env
$json_appsetings.KernelConfiguration.ClientId = "10004"
ConvertTo-Json $json_appsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"


