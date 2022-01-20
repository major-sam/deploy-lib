$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$Config = 'C:\inetpub\WebsiteCom-Public\Web.config'
$webdoc = [Xml](Get-Content $Config)
($webdoc.configuration.appSettings| %{$_.add} |? {$_.key -like 'ServerAddress'}).value = $CurrentIpAddr+ ':8082'
$webdoc.configuration."system.serviceModel".client.endpoint |% {$_.address= $_.address.replace('localhost', $CurrentIpAddr) }
$webdoc.Save($Config)

$oldString = '<sessionState mode="SQLServer" allowCustomSqlDatabase="true" sqlConnectionString="Server=172.16.0.153;Initial catalog=WebSite_ASPState;User Id=website;Password=w#bs!t#;"/>'
$newString = '<sessionState cookieless="UseCookies" cookieName="mySessionCookie" mode="StateServer" stateConnectionString="tcpip=localhost:42424" timeout="20" useHostingIdentity="false" />'
(Get-Content -Path $webConfig -Encoding UTF8).replace($oldString,$newString) | Set-Content -Path $Config -Encoding UTF8
