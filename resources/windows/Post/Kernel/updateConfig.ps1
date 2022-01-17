$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { 
  $_.interfaceindex -ne 1
  }).IPAddress.trim()
$Config = 'C:\Kernel\settings.xml'
$webdoc = [Xml](Get-Content $Config)

$tmp = ($webdoc.Settings.SiteIPs).FirstChild.CloneNode(1)
$tmp.'#text'=$CurrentIpAddr
$tmp.WorkerId='57'
$tmp.ClientId = '777'
$webdoc.Settings.SiteIPs.AppendChild($tmp)

$tmp = ($webdoc.Settings.SiteIPs).FirstChild.CloneNode(1)
$tmp.'#text'=$CurrentIpAddr
$tmp.ClientId = '7773'
$webdoc.Settings.SiteIPs.AppendChild($tmp)

$webdoc.Save($Config)

