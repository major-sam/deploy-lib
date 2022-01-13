Import-module '.\scripts\sideFunctions.psm1'


#get release params
###vars
$targetDir = "C:\inetpub\ClientWorkPlace\UniRu"

$webConfig = "$targetDir\Web.config"
$apiWebConfig = "$apiTargetDir\Web.config"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$ProgressPreference = 'SilentlyContinue'




###
#XML values replace UniRu
####
Write-Host -ForegroundColor Green "[INFO] Edit web.config of $webConfig"
$webdoc = [Xml](Get-Content $webConfig)
$obj = $webdoc.configuration.connectionStrings.add | where {$_.name -eq 'DataContext' }
$obj.connectionString = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"
$obj = $webdoc.configuration.connectionStrings.add | where {$_.name -eq 'UniPaymentsServiceUrl' }
$obj.connectionString = "https://${env:COMPUTERNAME}.bb-webapps.com:54381"
$obj = $webdoc.configuration.cache.db
$obj.connection = "data source=localhost;initial catalog=UniRu;Integrated Security=true;MultipleActiveResultSets=True;"
($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'DefaultService' }).host = $IPAddress
($webdoc.configuration.Grpc.services.add | where {$_.name -eq 'PromocodeAdminService' }).host = $IPAddress
$webdoc.Save($webConfig)



Write-Host -ForegroundColor Green "[INFO] Done"

