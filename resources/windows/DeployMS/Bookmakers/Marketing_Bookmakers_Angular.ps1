import-module '.\scripts\sideFunctions.psm1'

$defaultDomain = "bb-webapps.com"
$pathtojson = "C:\Services\Marketing\BaltBet.MarketingService.Bookmakers\assets\config.json"
###
#Json values replace
####
Write-Host -ForegroundColor Green "[info] edit json files"
$jsonAppsetings = Get-Content -Raw -path $pathtojson | ConvertFrom-Json 
$jsonAppsetings.apiUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):9880"
ConvertTo-Json $jsonAppsetings -Depth  1 | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth 1"
