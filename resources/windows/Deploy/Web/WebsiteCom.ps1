#get release params

$targetDir  = 'C:\inetpub\WebsiteCom'
$webConfig = "$targetDir\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

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
$webdoc.configuration.'system.serviceModel'.client.endpoint | ForEach-Object {
	$_.address = ($_.address).replace("localhost","$($CurrentIpAddr)") }
$webdoc.configuration.Services.add | %{ if ($_.name -eq "TicketService"){
	$_.host = $CurrentIpAddr; $_.port = "5037"}}
$webdoc.configuration.'system.web'.sessionState.RemoveAllAttributes()
foreach ($attr in $attrs.GetEnumerator()) {    
    $webdoc.configuration.'system.web'.SelectSingleNode('//sessionState').SetAttribute($attr.Name, $attr.Value)
}
$webdoc.Save($webConfig)


$reportval =@"
[WebMobile]
$WebConfig

	(.configuration.appSettings.add | where {
		_.key -like "ServerAddress" }).value = $CurrentIpAddr+":8082"
	(.configuration.appSettings.add | where {
		_.key -like "SiteServerAddress"}).value = $CurrentIpAddr+":8088"
	(.configuration.appSettings.add | where {
		_.key -like "SiteServerAddressLogin"}).value = $CurrentIpAddr+":8088"
	(.configuration.appSettings.add | where {
		_.key -like "IsSuperexpressEnabled"}).value = "true"
	.configuration.'system.serviceModel'.client.endpoint | ForEach-Object {
		_.address = (_.address).replace("localhost","$($CurrentIpAddr)") }
	.configuration.'system.web'.sessionState.RemoveAllAttributes()
	foreach (attr in attrs.GetEnumerator()) {    
		.configuration.'system.web'.SelectSingleNode('//sessionState').SetAttribute(attr.Name, attr.Value)
	}
$('='*60)

"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8

Write-Host -ForegroundColor Green "[INFO] Done"

