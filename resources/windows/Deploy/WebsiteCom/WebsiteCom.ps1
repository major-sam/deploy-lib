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
$webdoc.configuration.'system.web'.sessionState.sqlConnectionString="Server=InProc;Initial catalog=WebSite_ASPState;User Id=website;Password=w#bs!t#;"
$webdoc.configuration.'system.serviceModel'.client.endpoint | ForEach-Object { $_.address = ($_.address).replace("localhost","$($CurrentIpAddr)") }
$webdoc.Save($webConfig)
