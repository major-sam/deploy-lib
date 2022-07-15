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


$webdoc.configuration.connectionStrings.add | % { 
	if ( $_.name -eq 'DataContext'){
		$_.connectionString = 
			"data source=localhost;"+
			"initial catalog=${dbName};"+
			"Integrated Security=true;"+
			"MultipleActiveResultSets=True;"
	}
	if ($_.name -eq 'UniPaymentsServiceUrl'){
		$_.connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:54381".ToLower()
	}
	if ($_.name -eq 'UniBonusServiceUrl'){
		$_.connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:4437".ToLower()
	}
	if ( $_.name -eq "Redis"){
		Write-Host 'REDIS CONFIG'
			$_.connectionString = $shortRedisStr 
	}
	if ($_.name -eq "UniAuthServiceUrl"){
		$_.connectionString = "https://$($env:COMPUTERNAME).bb-webapps.com:${uasPort}".ToLower()
	}
	if ($_.name -eq 'UniEventServiceUrl'){
		$_.connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:4435".ToLower()
	}
}

$webdoc.configuration.Grpc.Services.add | %{
 if ($_.name -eq "LogoutServiceClient"){
	 $_.host = $IPAddress
	 $_.port = "5307"
 }
}

$webdoc.configuration."system.web".sessionState.providers.add.connectionString = 
	"$shortRedisStr,syncTimeout=10000,"+
	"allowAdmin=True,connectTimeout=50000"
$webdoc.configuration."system.web".sessionState.providers.add.accessKey = $redispasswd
$webdoc.configuration.cache.redis.connection = 
	"$shortRedisStr,syncTimeout=10000,"+
	"allowAdmin=True,connectTimeout=50000,"+
	"ssl=False,abortConnect=False,"+
	"connectRetry=10,proxy=None,configCheckSeconds=5"

$webdoc.configuration.cache.db.connection =
	"data source=localhost;"+
	"initial catalog=${dbName};"+
	"Integrated Security=true;"+
	"MultipleActiveResultSets=True;"

$webdoc.configuration.Grpc.services.add | % { 
	if ($_.name -eq 'DefaultService'){
		$_.host = $IPAddress
	}

	if($_.name -eq 'PromocodeAdminService'){
		$_.host = $IPAddress
	}

	if ($_.name -eq 'TicketService'){
		$_.host = $IPAddress
			$_.port = $ticketServicePort
	}
}

$webdoc.configuration.appSettings.add | % {
	if ($_.key -eq 'ServerInstance'){
		$_.value = $serverInstance}
}

#configuration.appSettings.SelectNodes add node enable swagger
$targetNode = $webdoc.configuration.appSettings.SelectNodes("add[@key='webapi:EnableSwagger']")
if($targetNode.Count){
	write-host 'remove old nodes'
	foreach($node in $targetNode){$node.ParentNode.RemoveChild($node)}
}

write-host 'creating node'
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

$webdoc.Save($webConfig)

	Write-Host -ForegroundColor Green "[INFO] Done"
