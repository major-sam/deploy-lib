import-module '.\scripts\sideFunctions.psm1'

# 2 Сервис WebTouch-Public

#get release params
$SiteFolder = "C:\inetpub\WebTouch-Public"
$SiteConfig = "$SiteFolder\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

Write-Host -ForegroundColor Green "[INFO] Edit web.config of WebTouch-Public"
$webdoc = [Xml](Get-Content $SiteConfig)
$webdoc.configuration.serverConfig.ServerAddress = "$($CurrentIpAddr):8082"
$webdoc.configuration.serverConfig.SiteServerAddress = "$($CurrentIpAddr):8088"
$Recaptcha = $webdoc.configuration.appSettings.add | Where-Object key -eq "IsRecaptchaEnabled"
$Recaptcha.value = "false"
$webdoc.Save($SiteConfig)

