
###vars
$targetDir = "C:\inetpub\KRM"
$KRMConfig ="$targetDir\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

### edit KRM Web.config
$conf = [Xml](Get-Content $KRMConfig)
if ($conf.configuration."system.serviceModel".client) {
	Write-Host "True"
	$conf.configuration."system.serviceModel".client |% {$_.endpoint |% {$_.address = $_.address.replace("localhost",$CurrentIpAddr)}}
	$conf.Save($KRMConfig)

$reportval = @"
	[KRM]
	$KRMConfig
		.configuration."system.serviceModel".client |% {_.endpoint |% {_.address = _.address.replace("localhost",$CurrentIpAddr)}}

	$('='*60)
"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
} else {
	Write-Host "[INFO] '`$conf.configuration."system.serviceModel".client in Web.config doesn't exist'"
}
