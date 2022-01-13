import-module '.\scripts\sideFunctions.psm1'

# 2 Сервис WebTouch

#get release params
$SiteFolder = "C:\inetpub\WebTouch"
$SiteConfig = "$SiteFolder\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

Write-Host -ForegroundColor Green "[INFO] Edit web.config of WebTouch"
$webdoc = [Xml](Get-Content $SiteConfig)
$webdoc.configuration.serverConfig.ServerAddress = "$($CurrentIpAddr):8082"
$webdoc.configuration.serverConfig.SiteServerAddress = "$($CurrentIpAddr):8088"
$webdoc.Save($SiteConfig)

