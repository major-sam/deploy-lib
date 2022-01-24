# Сервис WebSite (baltbetru)

#get release params
$SiteFolder = "C:\inetpub\WebSite"
$SiteConfig = "$SiteFolder\Web.config"
$wildcardDomain = "bb-webapps.com"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

Write-Host -ForegroundColor Green "[INFO] Edit web.config of WebSite"
$webdoc = [Xml](Get-Content $SiteConfig)
$webdoc.configuration.rabbitMqConfig.isEnabled = "true"
$webdoc.configuration.rabbitMqConfig.connectionString = "host=localhost:5672"
$webdoc.configuration.cache.redis.add.name = "account"
$webdoc.configuration.cache.redis.add.connection = "localhost:6379"
$webdoc.configuration.appSettings.add | %{ if ($_.key -eq "ClientId"){
		$_.value = "7773"}}
($webdoc.configuration.appSettings.add | 
	Where-Object key -eq "ServerAddress").value = "$($CurrentIpAddr):8082"
($webdoc.configuration.appSettings.add | 
	Where-Object key -eq "IsCaptchaEnabled").value = "false"
($webdoc.configuration.appSettings.add | 
	Where-Object key -eq "IsRegistrationCaptchaEnabled").value = "false"
($webdoc.configuration.connectionStrings.add | 
	Where-Object name -eq "UniPaymentsServiceUrl").connectionString = "https://${env:COMPUTERNAME}.$($wildcardDomain):54381"
if(Get-Member -inputobject $webdoc.configuration -name 'system.serviceModel' -Membertype Properties){
	$webdoc.configuration.'system.serviceModel'.client.endpoint.address = "net.tcp://$($CurrentIpAddr):8150/PromoManager"
}
$webdoc.Save($SiteConfig)

$reportval =@"
[WebMobile]
$SiteConfig

	.configuration.rabbitMqConfig.isEnabled = "true"
	.configuration.rabbitMqConfig.connectionString = "host=localhost:5672"
	.configuration.cache.redis.add.name = "account"
	.configuration.cache.redis.add.connection = "localhost:6379"
	.configuration.appSettings.add | %{ if (_.key -eq "ClientId"){
			_.value = "7773"}}
	(.configuration.appSettings.add | 
		Where-Object key -eq "ServerAddress").value = "$($CurrentIpAddr):8082"
	(.configuration.appSettings.add | 
		Where-Object key -eq "IsCaptchaEnabled").value = "false"
	(.configuration.appSettings.add | 
		Where-Object key -eq "IsRegistrationCaptchaEnabled").value = "false"
	(.configuration.connectionStrings.add | 
		Where-Object name -eq "UniPaymentsServiceUrl").connectionString = "https://${env:COMPUTERNAME}.$($wildcardDomain):54381"
	if(Get-Member -inputobject .configuration -name 'system.serviceModel' -Membertype Properties){
		.configuration.'system.serviceModel'.client.endpoint.address = "net.tcp://$($CurrentIpAddr):8150/PromoManager"
}
$('='*60)

"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8

Write-Host -ForegroundColor Green "[INFO] Done"

