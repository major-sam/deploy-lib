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

$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

### copy files

###
#Json values replace
####
Write-Host -ForegroundColor Green "[info] edit json files"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % {$_ -replace  '[\s^]//.*', ""} | ConvertFrom-Json 
$fileLogs = $jsonAppsetings.Serilog.WriteTo | where {$_.Name -eq 'File' }
$fileLogs.Args.path = "c:\Logs\MarketingService\MarketingService.log"
$jsonAppsetings.FilesService.UploadFolderPath = "C:\inetpub\MarketingImages"
$jsonAppsetings.FilesService.PublicationBaseUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):9883".ToLower()
$jsonAppsetings.UrlConfig.newsUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):9882/desktop/info/news".ToLower()
$jsonAppsetings.UrlConfig.promotionRulesUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):9882/desktop/static-page/promotion-rules".ToLower()
$jsonAppsetings.UrlConfig.linkAccountToUniUrl = "https://$($env:COMPUTERNAME).$($defaultDomain):9882/marketing/authorize?data=".ToLower()
$jsonAppsetings.connectionStrings.RabbitMQ = $shortRabbitStr
ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"
