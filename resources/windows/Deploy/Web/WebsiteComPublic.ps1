$redispasswd = "$($ENV:REDIS_CREDS_PWD)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PWD)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$Config = 'C:\inetpub\WebsiteCom-Public\Web.config'

$webdoc = [Xml](Get-Content $Config)
($webdoc.configuration.appSettings| %{$_.add} |? {
	$_.key -like 'ServerAddress'}).value = $CurrentIpAddr+ ':8082'
$webdoc.configuration."system.serviceModel".client.endpoint |% {
	$_.address= $_.address.replace('localhost', $CurrentIpAddr) }
$attrs = @{
 'cookieless' =  "UseCookies"
 'cookieName' = "mySessionCookie"
 'mode' = "StateServer" 
 'stateConnectionString' = "tcpip=localhost:42424"
 'timeout' = "20"
 'useHostingIdentity' = "false"
}
$webdoc.configuration.'system.web'.sessionState.RemoveAllAttributes()
foreach ($attr in $attrs.GetEnumerator()) {    
    $webdoc.configuration.'system.web'.SelectSingleNode('//sessionState').SetAttribute($attr.Name, $attr.Value)
}
$webdoc.configuration.globalLog.rabbitmq.defaultConnectionString ="$shortRabbitStr;publisherConfirms=true; timeout=100; requestedHeartbeat=0"
$webdoc.configuration.rabbitMqConfig.connectionString =$shortRabbitStr
($webdoc.configuration.cache.redis.add| ? {$_.name -ilike "account"}).connection = $shortRedisStr
($webdoc.configuration.connectionStrings.add| ? {$_.name -ilike "RedisChatStorage"}).connectionString = $shortRedisStr
$webdoc.Save($Config)

Write-Host -ForegroundColor Green "[INFO] Done"

