Import-module '.\scripts\sideFunctions.psm1'
#get release params
###vars
$apiTargetDir = "C:\inetpub\ClientWorkPlace\UniruWebApi"
$apiWebConfig = "$apiTargetDir\Web.config"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1 }).IPAddress.trim()
$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$redisPwdStr = "password=$redispasswd"
$shortRedisStr = "$($env:REDIS_HOST):$($env:REDIS_Port),$redisPwdStr"
###
#XML values replace UniruWebApi
####
Write-Host -ForegroundColor Green "[INFO] Edit web.config of $apiWebConfig"
$webdoc = [Xml](Get-Content $apiWebConfig)

($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'UniPaymentsServiceUrl' 
}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:54381".ToLower()

($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'DataContext' 
}).connectionString = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"

($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'UniEventServiceUrl' 
}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:4435".ToLower()

($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'UniBonusServiceUrl' 
}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:44320".ToLower()

($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'UniAccountRecoveryServiceUrl' 
}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:56542".ToLower()

($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'UniIdentServiceUrl' 
}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:44351".ToLower()

$webdoc.configuration.cache.db.connection = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"
$ConnectionStringsAdd = $webdoc.CreateElement('add')
$ConnectionStringsAdd.SetAttribute("name", "OAuth.LastLogoutUrl")
$ConnectionStringsAdd.SetAttribute("connectionString", "https://${env:COMPUTERNAME}.gkbaltbet.local:449/account/logout/last")
$webdoc.configuration.connectionStrings.AppendChild($ConnectionStringsAdd)
($webdoc.configuration.Grpc.services.add | where { $_.name -eq 'DefaultService' }).host = $IPAddress
($webdoc.configuration.Grpc.services.add | where { $_.name -eq 'PromocodeAdminService' }).host = $IPAddress
#configuration.appSettings.SelectNodes add node enable swagger   
Write-Host 'REDIS CONFIG'
$webdoc.configuration.connectionStrings.add | % {
	if ($_.name -eq "Redis") { $_.connectionString = $shortRedisStr } 
}
$webdoc.configuration."system.web".sessionState.providers.add.connectionString = "$shortRedisStr,syncTimeout=10000,allowAdmin=True,connectTimeout=50000"
$webdoc.configuration."system.web".sessionState.providers.add.accessKey = $redispasswd
$webdoc.configuration.cache.redis.connection = "$shortRedisStr,syncTimeout=10000,allowAdmin=True,connectTimeout=50000,ssl=False,abortConnect=False,connectRetry=10,proxy=None,configCheckSeconds=5"
$targetNode = $webdoc.configuration.appSettings.SelectNodes("add[@key='webapi:EnableSwagger']")
if ($targetNode.Count) {
	write-host 'remove old nodes'
	foreach ($node in $targetNode) { $node.ParentNode.RemoveChild($node) }
}
write-host 'creating node'
$webdoc.configuration.appSettings.add | fc
$new = $webdoc.CreateElement("add")
$new.SetAttribute("key", "webapi:EnableSwagger")
$new.SetAttribute( "value", "false")
$webdoc.configuration.appSettings.AppendChild($new)
$webdoc.Save($apiWebConfig)

Write-Host -ForegroundColor Green "[INFO] Done"

