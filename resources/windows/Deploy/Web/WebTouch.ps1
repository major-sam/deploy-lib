import-module '.\scripts\sideFunctions.psm1'

# 2 Сервис WebTouch

#get release params
$SiteFolder = "C:\inetpub\WebTouch"
$SiteConfig = "$SiteFolder\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$webtouchLogsPath = "C:\Logs\WebTouch\WebTouch"

Write-Host -ForegroundColor Green "[INFO] Edit web.config of WebTouch"
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
$webdoc.Save($SiteConfig)
