Import-module '.\scripts\sideFunctions.psm1'

#get release params
###vars
Write-Host "[INFO] Check if 'env:Zone' exists"
if(Test-Path 'env:Zone') {
	$zone = $env:Zone
	$zonePath = $env:Zonepath
	$defaultDir = "uniru"
	$dbName = "Uni${zone}"
	$serverInstance = "Uni${zone}"
	$targetDir = "${zonePath}\uni${zone}"
	$logsPath = "C:\Logs\Uni${zone}\uni${zone}"
	Write-Host "[INFO] Zone: ${zone}, Path: ${zonePath}, dbname: ${dbName}, instance: ${serverInstance}, targetDir: ${targetDir}"
	if(!($zone -eq "Ru")){
		Write-Host -ForegroundColor Green "[INFO] Rename catalogs"
		Rename-Item -Path "${zonePath}\${defaultDir}" -NewName "Uni${zone}" -Force	
	}
} else {
	Write-Host "[INFO] 'env:Zone' does not exist. Set default zone RU."
	$zone = "Ru"
	$dbName = "Uni${zone}"
	$serverInstance = "Uni${zone}"
	$targetDir = "C:\inetpub\ClientWorkPlace\uni${zone}"
	$logsPath = "C:\Logs\ClientWorkPlace\Uni${zone}"
}

$webConfig = "$targetDir\Web.config"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)"
$redisPwdStr= "password=$redispasswd"
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),$redisPwdStr"
$uasPort = 449
$ticketServicePort = "5037"


###
#XML values replace UniRu
####
Write-Host -ForegroundColor Green "[INFO] Edit web.config of $webConfig"
$webdoc = [Xml](Get-Content $webConfig)

Write-Host "####  Edit log file path"
try {
	$logPath = @{
		"globallog-deadletter_global-appender" 	= "$($logsPath)\%property{site}\global-log\global-dead-"
		"RootFileAppender"						= "$($logsPath)\%property{site}\"
		"EasyNetQAppender"						= "$($logsPath)\%property{site}\bus\"
		"SignalRAppender"						= "$($logsPath)\%property{site}\SignalR\"
	}
	foreach ($key in $logPath.Keys) {
		($webdoc.configuration.log4net.appender | where {$_.name -eq $key}).file.value = $logPath.$key
	}
} catch {
	Write-Host "[WARN] Log settings doesn't find...."
}


($webdoc.configuration.connectionStrings.add | where { $_.name -eq 'DataContext'
	}).connectionString = "data source=localhost;initial catalog=${dbName};Integrated Security=true;MultipleActiveResultSets=True;"
($webdoc.configuration.connectionStrings.add | where { $_.name -eq 'UniPaymentsServiceUrl'
	}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:54381".ToLower()
($webdoc.configuration.connectionStrings.add | where { $_.name -eq 'UniBonusServiceUrl'
	}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:4437".ToLower()
Write-Host 'REDIS CONFIG'
if ($webdoc.configuration.connectionStrings.add | where { $_.name -eq "Redis"}){
	($webdoc.configuration.connectionStrings.add | where { $_.name -eq "Redis"}).connectionString = $shortRedisStr 
}

$logoutService = $webdoc.configuration.Grpc.Services.add | Where-Object name -eq "LogoutServiceClient"
$logoutService.host = $IPAddress
$logoutService.port = "5307"

$authUrl = $webdoc.configuration.connectionStrings.add | Where-Object name -eq "UniAuthServiceUrl"
$authUrl.connectionString = "https://$($env:COMPUTERNAME.ToLower()).bb-webapps.com:${uasPort}"

$webdoc.configuration."system.web".sessionState.providers.add.connectionString = "$shortRedisStr,syncTimeout=10000,allowAdmin=True,connectTimeout=50000"
$webdoc.configuration."system.web".sessionState.providers.add.accessKey = $redispasswd
$webdoc.configuration.cache.redis.connection = "$shortRedisStr,syncTimeout=10000,allowAdmin=True,connectTimeout=50000,ssl=False,abortConnect=False,connectRetry=10,proxy=None,configCheckSeconds=5"

($webdoc.configuration.connectionStrings.add | where { $_.name -eq 'UniEventServiceUrl'
	}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:4435".ToLower()

$webdoc.configuration.cache.db.connection = "data source=localhost;initial catalog=${dbName};Integrated Security=true;MultipleActiveResultSets=True;"

($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'DefaultService' }).host = $IPAddress

if ($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'PromocodeAdminService'}){
	($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'PromocodeAdminService'}).host = $IPAddress
}

if ($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'TicketService'}){
	($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'TicketService'}).host = $IPAddress
	($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'TicketService'}).port = $ticketServicePort
}

#configuration.appSettings.SelectNodes add node enable swagger
$targetNode = $webdoc.configuration.appSettings.SelectNodes("add[@key='webapi:EnableSwagger']")
if($targetNode.Count){
	write-host 'remove old nodes'
	foreach($node in $targetNode){$node.ParentNode.RemoveChild($node)}
}

write-host 'creating node'
$webdoc.configuration.appSettings.add| fc
$new = $webdoc.CreateElement("add")
$new.SetAttribute("key","webapi:EnableSwagger")
$new.SetAttribute( "value","false")
if (!$webdoc.configuration.appSettings.add.Contains($new)){
	$webdoc.configuration.appSettings.AppendChild($new)
}
if ($webdoc.configuration.ckfinder){
		(($webdoc.configuration.ckfinder.backends.backend|	where {
			$_.name -ilike "default" }).option| where {
				$_.name -ilike 'root'}).value = 'c:\inetpub\images'
}
else{
	write-host 'CKFinder moved to admin app'
}

# Для UniCom
if ($webdoc.configuration.appSettings.add | where {$_.key -eq 'ServerInstance'}){
	($webdoc.configuration.appSettings.add | where {$_.key -eq 'ServerInstance'}).value = $serverInstance
}

$webdoc.Save($webConfig)

Write-Host -ForegroundColor Green "[INFO] Done"
