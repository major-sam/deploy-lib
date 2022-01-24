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
	}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:54381"
$webdoc.configuration.cache.db.connection = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"
$ConnectionStringsAdd = $webdoc.CreateElement('add')
$ConnectionStringsAdd.SetAttribute("name","OAuth.LastLogoutUrl")
$ConnectionStringsAdd.SetAttribute("connectionString","https://${env:COMPUTERNAME}.gkbaltbet.local:449/account/logout/last")
$webdoc.configuration.connectionStrings.AppendChild($ConnectionStringsAdd)
($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'DefaultService' }).host = $IPAddress
($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'PromocodeAdminService' }).host = $IPAddress
$webdoc.Save($apiWebConfig)


$reportval =@"
[UniRu]
$webConfig
	(.configuration.connectionStrings.add | where {
		_.name -eq 'UniPaymentsServiceUrl' 
		}).connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:54381"
	.configuration.cache.db.connection = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"
	.CreateElement('add')
		>.SetAttribute("name","OAuth.LastLogoutUrl")
		>.SetAttribute("connectionString","https://${env:COMPUTERNAME}.gkbaltbet.local:449/account/logout/last")
	.configuration.connectionStrings.AppendChild($ConnectionStringsAdd)
	(.configuration.Grpc.services.add | where {_.name -eq 'DefaultService' }).host = $IPAddress
	(.configuration.Grpc.services.add | where {_.name -eq 'PromocodeAdminService' }).host = $IPAddress
$('='*60)

"@

add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
Write-Host -ForegroundColor Green "[INFO] Done"

