Write-Host -ForegroundColor Green "[INFO] Edit web.config of $webConfig"
$webConfig = "c:\inetpub\WebApiAuth\Web.config"
$webdoc = [Xml](Get-Content $webConfig)
$webdoc.configuration.connectionStrings.add | % {if ($_.name -eq 'OAuth.LastLogoutUrl') {
		$_.connectionString = "https://$($env:COMPUTERNAME).bb-webapps.com:449/account/logout/last"}}
$webdoc.Save($webConfig)
Write-Host -ForegroundColor Green "[INFO] Done"

$reportval =@"
[WebApiAuth]
$webConfig
	.configuration.connectionStrings.add | % {
		if (_.name -eq 'OAuth.LastLogoutUrl') {
			_.connectionString = "https://$($env:COMPUTERNAME).bb-webapps.com:449/account/logout/last"}}
"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8

Write-Host -ForegroundColor Green "[INFO] Done"

