import-module '.\scripts\sideFunctions.psm1'

$defaultDomain = "bb-webapps.com"
$targetDir= "C:\Services\Marketing\BaltBet.MarketingService.Admin"
$pathtojson = "$targetDir\config.json"
$webConfig = "$targetDir\index.html"
###
#Json values replace
####
Write-Host -ForegroundColor Green "[info] edit json files"
$jsonAppsetings = Get-Content -Raw -path $pathtojson | ConvertFrom-Json 
$jsonAppsetings.apiUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):9880"
ConvertTo-Json $jsonAppsetings -Depth  1 | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth 1"
###
#XML values replace in html
####
$xmlContent = Get-Content -Encoding UTF8 $webConfig |
   % {$_ -replace "^.*base.*$", "<base href=`"https://$($env:COMPUTERNAME).$($defaultDomain):9881/`">"} 
set-Content -Encoding UTF8 -Path $webConfig -Value $xmlContent
