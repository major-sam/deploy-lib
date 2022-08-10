# Сервис WebSite (baltbetru)

#get release params
$SiteFolder = "C:\inetpub\WebSite"
$SiteConfig = "$SiteFolder\Web.config"
$wildcardDomain = "bb-webapps.com"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)"
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)"
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

Write-Host -ForegroundColor Green "[INFO] Edit web.config of WebSite"
$webdoc = [Xml](Get-Content $SiteConfig)
$webdoc.configuration.rabbitMqConfig.isEnabled = "true"
$webdoc.configuration.rabbitMqConfig.connectionString = $shortRabbitStr
$webdoc.configuration.cache.redis.add.name = "account"
$webdoc.configuration.cache.redis.add.connection = $shortRedisStr
$webdoc.configuration.appSettings.add | %{
	if ($_.key -eq "ClientId"){ $_.value = "7773"}
	if ($_.key -eq "ServerAddress"){ $_.value = "$($CurrentIpAddr):8082"}
	if ($_.key -eq "IsCaptchaEnabled"){ $_.value = "false"}
	if ($_.key -eq "IsRegistrationCaptchaEnabled"){ $_.value = "false"}
}

$webdoc.configuration.connectionStrings.add | % {
	if ($_.name -eq "Redis" ) { $_.connectionString = $shortRedisStr }
	if ($_.name -eq "UniPaymentsServiceUrl" ) { $_.connectionString = "https://${env:COMPUTERNAME}.$($wildcardDomain):54381"}
}

# Добавляем/изменяем параметр BaseRedirectUniUrl
$BaseRedirectUniUrl = ($webdoc.configuration.appSettings.add | Where-Object key -eq "BaseRedirectUniUrl")
if ($BaseRedirectUniUrl) {
	Write-Host "[INFO] BaseRedirectUniUrl exists, change value"
	($webdoc.configuration.appSettings.add | Where-Object key -eq "BaseRedirectUniUrl").value = "https://${env:COMPUTERNAME}.$($wildcardDomain):4443"
} else {
	Write-Host "[INFO] BaseRedirectUniUrl does not exits, add new element"
	$webdoc.configuration.appSettings.add | Format-Custom
	$new = $webdoc.CreateElement("add")
	$new.SetAttribute("key", "BaseRedirectUniUrl")
	$new.SetAttribute("value", "https://${env:COMPUTERNAME}.$($wildcardDomain):4443")
	$webdoc.configuration.appSettings.AppendChild($new)
}

$webdoc.configuration.Grpc.Services.add | %{
	if ($_.name -eq "TicketService"){$_.host = $CurrentIpAddr; $_.port = "5037"}
	if ($_.name -eq "LogoutServiceClient"){$_.host = $CurrentIpAddr; $_.port = "5037"}
}

if(Get-Member -inputobject $webdoc.configuration -name 'system.serviceModel' -Membertype Properties){
	$webdoc.configuration.'system.serviceModel'.client.endpoint.address = "net.tcp://$($CurrentIpAddr):8150/PromoManager"
}
$webdoc.Save($SiteConfig)

Write-Host -ForegroundColor Green "[INFO] Done"

