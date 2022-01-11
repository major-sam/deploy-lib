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

#хз что это но это не работает
#$ClientId = $webdoc.configuration.appSettings.add | Where-Object key -eq "ClientId"
#$$ClientId.value = "7773" 

$webdoc.configuration.appSettings.add | %{ if ($_.key -eq "ClientId"){
		$_.value = "7773"}}
$ServerAddress = $webdoc.configuration.appSettings.add | Where-Object key -eq "ServerAddress"
$ServerAddress.value = "$($CurrentIpAddr):8082"

$Captcha = $webdoc.configuration.appSettings.add | Where-Object key -eq "IsCaptchaEnabled"
$Captcha.value = "false"

$RegCaptcha = $webdoc.configuration.appSettings.add | Where-Object key -eq "IsRegistrationCaptchaEnabled"
$RegCaptcha.value = "false"

$UniPaymentUrl = $webdoc.configuration.connectionStrings.add | Where-Object name -eq "UniPaymentsServiceUrl"
$UniPaymentUrl.connectionString = "https://${env:COMPUTERNAME}.$($wildcardDomain):54381"

$webdoc.configuration.'system.serviceModel'.client.endpoint.address = "net.tcp://$($CurrentIpAddr):8150/PromoManager"
$webdoc.Save($SiteConfig)
