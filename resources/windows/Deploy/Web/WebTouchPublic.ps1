import-module '.\scripts\sideFunctions.psm1'

# 2 Сервис WebTouch-Public

#get release params
$SiteFolder = "C:\inetpub\WebTouch-Public"
$SiteConfig = "$SiteFolder\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$webtouchpubLogsPath = "C:\Logs\WebTouch\WebTouch-Public"


Write-Host -ForegroundColor Green "[INFO] Edit web.config of WebTouch-Public"
$webdoc = [Xml](Get-Content $SiteConfig)

Write-Host "####  Edit log file path"
try {
	$logPath = @{
		"RollingLogFileAppender" = "$($webtouchLogsPath)\Log"
	}
	foreach ($key in $logPath.Keys) {
		($webdoc.configuration.log4net.appender | where {$_.name -eq $key}).file.value = $logPath.$key
	}
} catch {
	Write-Host "[WARN] Log settings doesn't find...."
}


$webdoc.configuration.serverConfig.ServerAddress = "$($CurrentIpAddr):8082"
$webdoc.configuration.serverConfig.SiteServerAddress = "$($CurrentIpAddr):8088"
($webdoc.configuration.appSettings.add | Where-Object key -eq "IsRecaptchaEnabled").value = "false"
$webdoc.Save($SiteConfig)
