###vars
$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
$targetDir = "C:\inetpub\KRM"
$KRMConfig ="$targetDir\Web.config"
$krmLogsPath = "C:\Logs\KRM"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$betCalculationServicePort = "5007"

### edit KRM Web.config
$xmlconfig = [Xml](Get-Content $KRMConfig)
if ($xmlconfig.configuration."system.serviceModel".client) {
	Write-Host "True"
	$xmlconfig.configuration."system.serviceModel".client |%	{
		$_.endpoint |% {
			$_.address = $_.address.replace("localhost",$CurrentIpAddr)
		}
	}
}
$xmlconfig.configuration.rabbitMqConfig.connectionString = $shortRabbitStr

$xmlconfig.configuration.appSettings.add | % { 
	if ($_.key -eq 'Redis.ConnectionString'){
		$_.value = $shortRedisStr
	}
	if ($_.key -eq 'IsBetCalculationEnabled'){
		$_.value = "true"
	}
}
# Можно удалить после выхода WEB-6904
if($xmlconfig.configuration."system.web".sessionState.providers.add.host) {
	$xmlconfig.configuration."system.web".sessionState.providers.add.host = "$($env:REDIS_HOST):$($env:REDIS_Port)"
}

# Для WEB-6904
if($xmlconfig.configuration."system.web".sessionState.providers.add.connectionString) {
	$xmlconfig.configuration."system.web".sessionState.providers.add.connectionString = "$shortRedisStr,syncTimeout=10000,allowAdmin=True,connectTimeout=50000"
}

$xmlconfig.configuration."system.web".sessionState.providers.add.accessKey = $redispasswd

# Для WEB-6904
if($xmlconfig.configuration.connectionStrings.add | ? {$_.name -ilike "Redis"}) {
	($xmlconfig.configuration.connectionStrings.add | ? {$_.name -ilike "Redis"}).connectionString = $shortRedisStr
}

$xmlconfig.configuration.Grpc.services.add | % { 
	if ($_.name -eq 'BetCalculationService'){
		$_.host = "localhost"
		$_.port = $betCalculationServicePort
	}
}

Write-Host "####  Edit log file path"
try {
	$logPath = @{
		"GeneralAppender" 		= "$($krmLogsPath)\cwsGenOps_"
		"AccountAppender"		= "$($krmLogsPath)\cwsAccOps_"
		"BetAppender"			= "$($krmLogsPath)\cwsBetsOps_"
		"AdminAppender"			= "$($krmLogsPath)\cwsAdminOps_"
		"ProxyAppender"			= "$($krmLogsPath)\cwsProxyOps_"
		"BrowserStackAppender"	= "$($krmLogsPath)\BrowserStack_"
	}
	foreach ($key in $logPath.Keys) {
		($xmlconfig.configuration.log4net.appender | where {$_.name -eq $key}).file.value = $logPath.$key
	}
} catch {
	Write-Host "[WARN] Log settings doesn't find...."
}

$xmlconfig.Save($KRMConfig)
