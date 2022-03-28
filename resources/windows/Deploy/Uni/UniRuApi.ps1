Import-module '.\scripts\sideFunctions.psm1'
#get release params
###vars
$apiTargetDir = "C:\inetpub\ClientWorkPlace\UniruWebApi"
$apiWebConfig = "$apiTargetDir\Web.config"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
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
$webdoc.configuration.cache.db.connection = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"
$ConnectionStringsAdd = $webdoc.CreateElement('add')
$ConnectionStringsAdd.SetAttribute("name","OAuth.LastLogoutUrl")
$ConnectionStringsAdd.SetAttribute("connectionString","https://${env:COMPUTERNAME}.gkbaltbet.local:449/account/logout/last")
$webdoc.configuration.connectionStrings.AppendChild($ConnectionStringsAdd)
($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'DefaultService' }).host = $IPAddress
($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'PromocodeAdminService' }).host = $IPAddress
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
$webdoc.configuration.appSettings.AppendChild($new)
$webdoc.Save($apiWebConfig)

Write-Host -ForegroundColor Green "[INFO] Done"

