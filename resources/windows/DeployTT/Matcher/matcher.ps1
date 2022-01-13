import-module '.\scripts\sideFunctions.psm1'
##### edit imorter json files
## mayby to env
$logPath = "C:\Logs\TradingTool\Baltbet.TradingTool.Matching-.txt"
$apiAddr =  (Get-NetIPAddress -AddressFamily IPv4 | ?{$_.InterfaceIndex -ne 1}).IPAddress.trim()
$apiPort = '50005'
$pathtojson = 'C:\Services\TradingTool\Services\Baltbet.TradingTool.MatchingSvc\appsettings.json'
$jsonDepth = 4

Write-Host -ForegroundColor Green "[info] edit json files"
$configFile = Get-Content -Raw -path $pathtojson 
## Json comment imporvement

$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'| ConvertFrom-Json

$json_appsetings.Serilog.WriteTo[0].Args.path = $logPath
ConvertTo-Json $json_appsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"


