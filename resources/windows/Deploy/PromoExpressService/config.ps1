Import-module '.\scripts\sideFunctions.psm1'

$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
$appSettings ="C:\Services\PromoExpressService\appsettings.json"  
$config = Get-Content -Path $appSettings -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$config.Serilog.WriteTo|% {
	if ($_.Name -like 'File'){
		$_.Args.path=  "C:\logs\PromoExpressService\PromoExpressService-{Date}.log"
	}
}
$config.ConnectionStrings.PromoExpressDb =  "data source=localhost;initial catalog=PromoExpressService;Integrated Security=true;MultipleActiveResultSets=True;"
$config.RabbitMqConnection.Host ="$shortRabbitStr; publisherConfirms=true; timeout=100; requestedHeartbeat=0"
ConvertTo-Json $config -Depth 4  | Format-Json | Set-Content $appSettings -Encoding UTF8

