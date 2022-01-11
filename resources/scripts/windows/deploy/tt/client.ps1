import-module '.\scripts\sideFunctions.psm1'
##### edit imorter json files
## mayby to env
$apiAddr =  (Get-NetIPAddress -AddressFamily IPv4 | ?{$_.InterfaceIndex -ne 1}).IPAddress.trim()
$apiPort = '50005'
$pathtojson = 'C:\Services\TradingTool\Client\Baltbet.TradingTool\appsettings.json'
$jsonDepth = 4
$ClientId = "10004"

Write-Host -ForegroundColor Green "[info] edit json files"
$configFile = Get-Content -Raw -path $pathtojson 
## Json comment imporvement

$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'| ConvertFrom-Json

$json_appsetings.Services.TradingToolBaseAddress =  "http://$($apiAddr):$($apiPort)/"
$json_appsetings.Auth.AdfsOptions.Authority = "https://adfs-next.gkbaltbet.local/adfs"
$json_appsetings.Auth.AdfsOptions.ClientId = $env:ADFSClientId
$json_appsetings.Auth.Authenticate = $true

ConvertTo-Json $json_appsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"



