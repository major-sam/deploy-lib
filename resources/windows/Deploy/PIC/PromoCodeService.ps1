Import-module '.\scripts\sideFunctions.psm1'

$appSettings ="C:\Services\PersonalInfoCenter\PromoCodeService\appsettings.json"  
Write-Host "[INFO] Edit BaltBet.CoefService configuration files..."
$config = Get-Content -Path $appSettings -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$config.Serilog.WriteTo|% {
	if ($_.Name -like 'File'){
		$_.Args.path=  "C:\logs\PersonalInfoCenter\PromoCodeService-{Date}.log"
	}
}

ConvertTo-Json $config -Depth 4  | Format-Json | Set-Content $appSettings -Encoding UTF8
