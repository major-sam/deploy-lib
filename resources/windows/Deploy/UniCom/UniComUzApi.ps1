Import-module '.\scripts\sideFunctions.psm1'
#get release params
###vars
$apiSourceDir = "C:\inetpub\UniComUz\uniruwebapi"
$newDir = "UniComUzWebApi"
$apiTargetDir = "C:\inetpub\UniComUz\${newDir}"
$apiWebConfig = "$apiTargetDir\Web.config"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1 }).IPAddress.trim()
$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$redisPwdStr = "password=$redispasswd"
$shortRedisStr = "$($env:REDIS_HOST):$($env:REDIS_Port),$redisPwdStr"
$UniComUzWebApiLogsPath = "C:\Logs\UniComUz\UniComUzWebApi"
$uasPort = 449
$dbName = "UniComUz"
$serverInstance = "UniComUz"

###
#XML values replace UniComUzWebApi
####
Write-Host -ForegroundColor Green "[INFO] Rename catalog $apiSourceDir"
Rename-Item -Path $apiSourceDir -NewName $newDir -Force

Write-Host -ForegroundColor Green "[INFO] Edit web.config of $apiWebConfig"
$webdoc = [Xml](Get-Content $apiWebConfig)

Write-Host "####  Edit log file path"
try {
	$logPath = @{
		"globallog-deadletter_global-appender" 	= "$($UniComUzWebApiLogsPath)\%property{site}\global-log\global-dead-"
		"RootFileAppender"						= "$($UniComUzWebApiLogsPath)\%property{site}\"
		"EasyNetQAppender"						= "$($UniComUzWebApiLogsPath)\%property{site}\bus\"
		"SignalRAppender"						= "$($UniComUzWebApiLogsPath)\%property{site}\SignalR\"
	}
	foreach ($key in $logPath.Keys) {
		($webdoc.configuration.log4net.appender | where {$_.name -eq $key}).file.value = $logPath.$key
	}
} catch {
	Write-Host "[WARN] Log settings doesn't find...."
}

($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'UniPaymentsServiceUrl' 
}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:54381".ToLower()

($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'DataContext' 
}).connectionString = "data source=localhost;initial catalog=${dbName};Integrated Security=true;MultipleActiveResultSets=True;"

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

$logoutService = $webdoc.configuration.Grpc.Services.add | Where-Object name -eq "LogoutServiceClient"
$logoutService.host = $IPAddress
$logoutService.port = "5307"

$authUrl = $webdoc.configuration.connectionStrings.add | Where-Object name -eq "UniAuthServiceUrl"
$authUrl.connectionString = "https://$($env:COMPUTERNAME.ToLower()).bb-webapps.com:${uasPort}"

$webdoc.configuration.cache.db.connection = "data source=localhost;initial catalog=${dbName};Integrated Security=true;MultipleActiveResultSets=True;"

$ConnectionStringsAdd = $webdoc.CreateElement('add')
$ConnectionStringsAdd.SetAttribute("name", "OAuth.LastLogoutUrl")
$ConnectionStringsAdd.SetAttribute("connectionString", "http://$($IPAddress):5307")
$webdoc.configuration.connectionStrings.AppendChild($ConnectionStringsAdd)

($webdoc.configuration.Grpc.services.add | where { $_.name -eq 'DefaultService' }).host = $IPAddress

if ($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'PromocodeAdminService'}){
	($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'PromocodeAdminService'}).host = $IPAddress
}

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

# Для UniCom
if ($webdoc.configuration.appSettings.add | where {$_.key -eq 'ServerInstance'}){
	($webdoc.configuration.appSettings.add | where {$_.key -eq 'ServerInstance'}).value = $serverInstance
}

$webdoc.Save($apiWebConfig)

Write-Host -ForegroundColor Green "[INFO] Done"

