Import-module '.\scripts\sideFunctions.psm1'

$serviceName = "BaltWidgetsClient"
$targetDir = "C:\Services\BaltWidgets\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\api.host.json"
$wildcardDomain = "bb-webapps.com"
$jsonDepth = 5


if (Test-path($pathtojson)) {
    Write-host "[INFO] Start ${serviceName} deploy script"
    Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
    $jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

    $jsonAppsetings.BackendUrl = "https://$($env:COMPUTERNAME.ToLower()).$($wildcardDomain):6001/EventWidget"
    
    ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
    Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"
}
else {
    Write-host "[INFO] $pathtojson does not exist. Skip deploy $serviceName."
}
