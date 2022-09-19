import-module '.\scripts\sideFunctions.psm1'

$redispasswd = $ENV:REDIS_CREDS_PSW
$shortRedisStr="$($env:REDIS_HOST),password=$redispasswd"
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$uniRuAdminDbName = "UniAdministration"

$ConfigPath = "c:\Services\UniPaymentsService\appsettings.json"
Write-Host -ForegroundColor Green "[INFO] Change settings $ConfigPath"
$config = Get-Content -Raw -path $ConfigPath 
$json_appsettings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$json_appsettings.kestrel.endpoints.https.url = "https://+$($ENV:UNIPAYMENT_SERVICE_PORT)"
$json_appsettings.kestrel.endpoints.https.Certificate.Location = "LocalMachine"
$json_appsettings.kestrel.endpoints.https.Certificate.Subject = "*.bb-webapps.com"
$json_appsettings.kestrel.endpoints.https.Certificate.Store = 'My'
$json_appsettings.ConnectionStrings.UniSiteSettings = "data source=localhost;initial catalog=${uniRuAdminDbName};Integrated Security=SSPI;MultipleActiveResultSets=True;"
$json_appsettings.Origins =@( 
		"https://$($env:COMPUTERNAME).bb-webapps.com:4443",
		"https://$($env:COMPUTERNAME).bb-webapps.com:4444",
		"https://website.bb-webapps.com",
		"https://$($env:COMPUTERNAME).bb-webapps.com:4445"
		)
$json_appsettings.Grpc.Services | % {
	if ($_.name -like "DefaultService" ){
		$_.Host = $env:COMPUTERNAME 
		$_.Port = 5003
	}
	if ($_.name -like "CupisInvoiceService" ){
		$_.Host = $env:COMPUTERNAME 
		$_.Port = 5003
	}
	if ($_.name -like "CupisPayoutService" ){
		$_.Host = $env:COMPUTERNAME 
		$_.Port = 5003
	}
}
$json_appsettings.ConnectionStrings.Redis = $shortRedisStr

ConvertTo-Json $json_appsettings -Depth 4 | Format-Json | Set-Content $ConfigPath -Encoding UTF8


Write-Host -ForegroundColor Green "[INFO] Done"

