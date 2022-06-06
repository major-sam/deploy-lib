Import-module '.\scripts\sideFunctions.psm1'

$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$uasPort = 449

# Меняем строки соединений в конфиге UniRu
$UniRuConfig = "C:\inetpub\ClientWorkPlace\uniru\Web.config"
$webdoc = [Xml](Get-Content $UniRuConfig)
$logoutService = $webdoc.configuration.Grpc.Services.add | Where-Object name -eq "LogoutServiceClient"
$logoutService.host = $IPAddress
$logoutService.port = "5307"

$authUrl = $webdoc.configuration.connectionStrings.add | Where-Object name -eq "UniAuthServiceUrl"
$authUrl.connectionString = "https://$($env:COMPUTERNAME).bb-webapps.com:${uasPort}"
$webdoc.Save($UniRuConfig)

# Меняем строки соединений в конфиге UniRuWebApi
$WebApiConfig = "C:\inetpub\ClientWorkPlace\uniruwebapi\Web.config"
$webdoc = [Xml](Get-Content $WebApiConfig)
$logoutService = $webdoc.configuration.Grpc.Services.add | Where-Object name -eq "LogoutServiceClient"
$logoutService.host = $IPAddress
$logoutService.port = "5307"

$authUrl = $webdoc.configuration.connectionStrings.add | Where-Object name -eq "UniAuthServiceUrl"
$authUrl.connectionString = "https://$($env:COMPUTERNAME).bb-webapps.com:${uasPort}"
$authUrl = $webdoc.configuration.connectionStrings.add | Where-Object name -eq "OAuth.LastLogoutUrl"
$authUrl.connectionString = "http://$($IPAddress):5307"
$webdoc.Save($WebApiConfig)

# Меняем строки соединений в конфиге WebSiteRu
$WebsiteRuConfig = "C:\inetpub\Website\Web.config"
$webdoc = [Xml](Get-Content $WebsiteRuConfig)
$logoutService = $webdoc.configuration.Grpc.Services.add | Where-Object name -eq "LogoutServiceClient"
$logoutService.host = $IPAddress
$logoutService.port = "5307"
$webdoc.Save($WebsiteRuConfig)


Import-Module -Force WebAdministration
$IISSite = "IIS:\Sites\UniAuthService"
$Bindings= @(
                @{protocol='https';bindingInformation="*:449:$($env:COMPUTERNAME).bb-webapps.com"}
            )
Set-ItemProperty $IISSite -name  Bindings -value $Bindings