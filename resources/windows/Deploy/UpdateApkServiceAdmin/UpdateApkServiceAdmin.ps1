import-module '.\scripts\sideFunctions.psm1'

$serviceFolder = "C:\Services\UpdateApk\UpdateApkServiceAdmin"
$pathtojson = "$($serviceFolder)\assets\config.json"

Write-Host -ForegroundColor Green "[info] edit json files"
$json_config = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 
$json_config.apiUrl = "https:\\$($env:COMPUTERNAME).bb-webapps.com:4458"

ConvertTo-Json $json_config -Depth 4| Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"


# Write-Host -ForegroundColor Green "Invoke InitDB.sql"
# Invoke-Sqlcmd -Database UpdateApkService -InputFile "$($serviceFolder)\DB\InitDB.sql"
