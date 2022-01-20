#get release params

$targetDir  = 'C:\inetpub\WebsiteCom'
$webConfig = "$targetDir\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

#XML values replace
####
$webdoc = [Xml](Get-Content -Encoding UTF8 $webConfig)
$obj = $webdoc.configuration.appSettings.add | where {$_.key -like "ServerAddress" }
$obj.value = $CurrentIpAddr+":8082"
$obj = $webdoc.configuration.appSettings.add | where {$_.key -like "SiteServerAddress"} 
$obj.value = $CurrentIpAddr+":8088"
$obj = $webdoc.configuration.appSettings.add | where {$_.key -like "SiteServerAddressLogin"} 
$obj.value = $CurrentIpAddr+":8088"
$obj = $webdoc.configuration.appSettings.add | where {$_.key -like "IsSuperexpressEnabled"} 
$obj.value = "true"
$webdoc.configuration.'system.serviceModel'.client.endpoint | ForEach-Object { $_.address = ($_.address).replace("localhost","$($CurrentIpAddr)") }
$webdoc.Save($webConfig)

$oldString = '<sessionState mode="SQLServer" allowCustomSqlDatabase="true"\n sqlConnectionString="Server=172.16.0.153;Initial catalog=WebSite_ASPState;User Id=website;Password=w#bs!t#;"/>'
$newString = '<sessionState cookieless="UseCookies" cookieName="mySessionCookie" mode="StateServer" stateConnectionString="tcpip=localhost:42424" timeout="20" useHostingIdentity="false" />'
(Get-Content -Path $webConfig -Encoding UTF8).replace($oldString,$newString) | Set-Content -Path $webConfig -Encoding UTF8
