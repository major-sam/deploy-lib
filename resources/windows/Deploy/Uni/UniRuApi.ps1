Import-module '.\scripts\sideFunctions.psm1'


#get release params
###vars
$apiTargetDir = "C:\inetpub\ClientWorkPlace\UniruWebApi"

# Проверяем существует ли каталог
if (Test-Path -Path $apiTargetDir) {
	Write-Host -ForegroundColor Green "[INFO] Target $apiTargetDir exists"
} else {
	$apiTargetDir = "C:\inetpub\ClientWorkPlace\webapi"
}

$apiWebConfig = "$apiTargetDir\Web.config"


$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$ProgressPreference = 'SilentlyContinue'



###
#XML values replace UniruWebApi
####
Write-Host -ForegroundColor Green "[INFO] Edit web.config of $apiWebConfig"
$webdoc = [Xml](Get-Content $apiWebConfig)
$obj = $webdoc.configuration.connectionStrings.add | where {$_.name -eq 'DataContext' }
$obj.connectionString = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"
$obj = $webdoc.configuration.connectionStrings.add | where {$_.name -eq 'UniPaymentsServiceUrl' }
$obj.connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:54381"
$obj = $webdoc.configuration.cache.db
$obj.connection = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"
$ConnectionStringsAdd = $webdoc.CreateElement('add')
$ConnectionStringsAdd.SetAttribute("name","OAuth.LastLogoutUrl")
$ConnectionStringsAdd.SetAttribute("connectionString","https://${env:COMPUTERNAME}.gkbaltbet.local:449/account/logout/last")
$webdoc.configuration.connectionStrings.AppendChild($ConnectionStringsAdd)
($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'DefaultService' }).host = $IPAddress
($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'PromocodeAdminService' }).host = $IPAddress
$webdoc.Save($apiWebConfig)

Write-Host -ForegroundColor Green "[INFO] Done"

