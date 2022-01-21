import-module '.\scripts\sideFunctions.psm1'

$ProgressPreference = 'SilentlyContinue'
$targetDir = 'C:\Kernel'
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$pathtojson = "$targetDir\appsettings.json "
###### edit json files

Write-Host -ForegroundColor Green "[info] edit json files"
$json_appsetings = Get-Content -Raw -path $pathtojson | ConvertFrom-Json 
$HttpsInlineCertStore = '
    {     }
'| ConvertFrom-Json 
$json_appsetings.Kestrel.EndPoints.HttpsInlineCertStore =  $HttpsInlineCertStore
ConvertTo-Json $json_appsetings -Depth 4| Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"

$reportval =@"
[Kernel]
$configfilepath
    .Kestrel.EndPoints.HttpsInlineCertStore =  $HttpsInlineCertStore
"@

add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
