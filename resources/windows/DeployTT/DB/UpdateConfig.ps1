import-module '.\scripts\sideFunctions.psm1'
$pathtojson = "C:\Services\TradingTool\Tools\Baltbet.TradingTool.Database.Updater\appsettings.json"
$ProxySeedVar = "C:/Services/TradingTool/Tools/Baltbet.TradingTool.Database.Updater/ProxySeed.json"
Write-Host -ForegroundColor Green "[info] edit json files"
$configFile = Get-Content -Raw -path $pathtojson 
## Json comment imporvement

$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'| ConvertFrom-Json

$json_appsetings.ProxySeed = $ProxySeedVar
ConvertTo-Json $json_appsetings -Depth 2 | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"
