Import-module '.\scripts\sideFunctions.psm1'

$appSettings ="C:\Services\PromoExpressService\appsettings.json"  
$config = Get-Content -Path $appSettings -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$config.Serilog.WriteTo|% {
	if ($_.Name -like 'File'){
		$_.Args.path=  "C:\logs\PromoExpressService\PromoExpressService-{Date}.log"
	}
}
$config.ConnectionStrings.PromoExpressDb =  "data source=localhost;initial catalog=PromoExpressService;Integrated Security=true;MultipleActiveResultSets=True;"
ConvertTo-Json $config -Depth 4  | Format-Json | Set-Content $appSettings -Encoding UTF8


$reportval =@"
[PromoExpressService]
$appSettings
	.Serilog.WriteTo|% {
		if (_.Name -like 'File'){
			_.Args.path=  "C:\logs\PromoExpressService\PromoExpressService-{Date}.log"
	}
$('='*60)


"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
