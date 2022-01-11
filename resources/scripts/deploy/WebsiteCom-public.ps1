$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$Config = 'C:\inetpub\WebsiteCom-Public\Web.config'
$webdoc = [Xml](Get-Content $Config)
($webdoc.configuration.appSettings| %{$_.add} |? {$_.key -like 'ServerAddress'}).value = $CurrentIpAddr+ ':8082'
$webdoc.configuration."system.serviceModel".client.endpoint |% {$_.address= $_.address.replace('localhost', $CurrentIpAddr) }
$webdoc.Save($Config)
