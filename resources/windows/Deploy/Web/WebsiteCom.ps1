#get release params

$targetDir  = 'C:\inetpub\WebsiteCom'
$webConfig = "$targetDir\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$attrs = @{
 'cookieless' =  "UseCookies"
 'cookieName' = "mySessionCookie"
 'mode' = "StateServer" 
 'stateConnectionString' = "tcpip=localhost:42424"
 'timeout' = "20"
 'useHostingIdentity' = "false"
}
#XML values replace
####
$webdoc = [Xml](Get-Content -Encoding UTF8 $webConfig)
($webdoc.configuration.appSettings.add | where {
	$_.key -like "ServerAddress" }).value = $CurrentIpAddr+":8082"
($webdoc.configuration.appSettings.add | where {
	$_.key -like "SiteServerAddress"}).value = $CurrentIpAddr+":8088"
($webdoc.configuration.appSettings.add | where {
	$_.key -like "SiteServerAddressLogin"}).value = $CurrentIpAddr+":8088"
($webdoc.configuration.appSettings.add | where {
	$_.key -like "IsSuperexpressEnabled"}).value = "true"

($webdoc.configuration.connectionStrings.add | where {
	$_.name -like "RedisChatStorage" }).connectionString = $shortRedisStr	

$webdoc.configuration.'system.serviceModel'.client.endpoint | ForEach-Object {
	$_.address = ($_.address).replace("localhost","$($CurrentIpAddr)") }
$webdoc.configuration.Grpc.Services.add | %{ if ($_.name -eq "TicketService"){
	$_.host = $CurrentIpAddr; $_.port = "5037"}}
$webdoc.configuration.'system.web'.sessionState.RemoveAllAttributes()
foreach ($attr in $attrs.GetEnumerator()) {    
    $webdoc.configuration.'system.web'.SelectSingleNode('//sessionState').SetAttribute($attr.Name, $attr.Value)
}
$webdoc.configuration.globalLog.rabbitmq.defaultConnectionString ="$shortRabbitStr;publisherConfirms=true; timeout=100; requestedHeartbeat=0"
$webdoc.configuration.rabbitMqConfig.connectionString =$shortRabbitStr
($webdoc.configuration.cache.redis.add| ? {$_.name -ilike "account"}).connection = $shortRedisStr
$webdoc.Save($webConfig)

Write-Host -ForegroundColor Green "[INFO] Done"

