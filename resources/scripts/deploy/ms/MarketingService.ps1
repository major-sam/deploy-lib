import-module '.\scripts\sideFunctions.psm1'

write-host 'marketingservice site deploy script'
#get release params

$defaultDomain = "bb-webapps.com"
$targetDir  = "C:\Services\Marketing\BaltBet.MarketingService"
$ProgressPreference = 'SilentlyContinue'
$webConfig = "$targetDir\Web.config"
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 4 
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

### copy files

###
#Json values replace
####
Write-Host -ForegroundColor Green "[info] edit json files"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % {$_ -replace  '[\s^]//.*', ""} | ConvertFrom-Json 
$fileLogs = $jsonAppsetings.Serilog.WriteTo | where {$_.Name -eq 'File' }
$fileLogs.Args.path = "c:\Logs\MarketingService\MarketingService.log"
$jsonAppsetings.FilesService.UploadFolderPath = "C:\inetpub\MarketingImages"
$jsonAppsetings.FilesService.PublicationBaseUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):9883"
ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"
