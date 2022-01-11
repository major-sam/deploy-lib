$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1 }).IPAddress.trim()
$webConfig = 'c:\inetpub\PaymenSystemHandlers\Web.config'
$webdoc = [Xml](Get-Content $webConfig)
$webdoc.configuration.log4net.appender.file.value = "c:\logs\Payments\Payment-handlers\"
$webdoc.configuration.appSettings.add| %{if ($_.key -like "ServerAddress"){
											$_.value =	"$($IPAddress):8082"}
											}
$webdoc.Save($webConfig)
