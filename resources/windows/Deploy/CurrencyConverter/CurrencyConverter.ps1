# PAY-145
# https://jira.baltbet.ru:8443/browse/PAY-145
# Path "C:\Services\CurrencyConverter\
# Log path C:\Logs\

Import-module '.\scripts\sideFunctions.psm1'


# Редактируем конфиг
$ServiceName = "CurrencyConverter"
$ccGrpcPort = 50004
$ccKestrelPort = 44314
$defaultDomain = "bb-webapps.com"

Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.${ServiceName} configuration files..."
$pathtojson = "C:\Services\${ServiceName}\appsettings.json"
$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

# Правим путь к лог файлу
$json_appsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\${ServiceName}\${ServiceName}.log"   
    }
}

# Правим настройки Kestrel и Grpc
$json_appsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${ccKestrelPort}/"
$json_appsetings.Kestrel.Endpoints.Https.Certificate.Subject = "*.bb-webapps.com"
$json_appsetings.Kestrel.Endpoints.GRPC.Url = "http://localhost:${ccGrpcPort}/"

# Добавляем пользователя
Write-Host -ForegroundColor Green "[INFO] Add $($env:DEPLOYUSER) to AllowedUsers list..."
$AllowedUsers = @(
    "GKBALTBET\achudov"
)
$AllowedUsers += "GKBALTBET\$($env:DEPLOYUSER)"
$json_appsetings.AllowedUsers = $AllowedUsers

ConvertTo-Json $json_appsetings -Depth 4 | Format-Json | Set-Content $pathtojson -Encoding UTF8

$reportVal = @"
[$ServiceName]
$config
	.Serilog.WriteTo| %{ if (_.Name -like 'File'){
			_.Args.path = "C:\Logs\${ServiceName}\${ServiceName}.log" 
		}
    .Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${ccKestrelPort}/"
    .Kestrel.EndPoints.Https.Certificate.Subject = "*.bb-webapps.com"
    .Kestrel.EndPoints.GRPC.Url = "http://localhost:${ccGrpcPort}/"
$('='*60)

"@

Add-Content -force -Path "$($env:WORKSPACE)\$($env:CONFIG_UPDATES)" -value $reportVal -Encoding utf8
