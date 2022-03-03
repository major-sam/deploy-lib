# KMM-677
# Сервис предназначен для восстановления аккаунта пользователя по коду подтверждения

Import-module '.\scripts\sideFunctions.psm1'


$ServiceName = "UniAccountRecoveryService"
$httpsUniRuPort = 4443
$accKestrelPort = 56542
$defaultDomain = "bb-webapps.com"
$kernelDbName = "BaltBetM"
$uniRuDbName = "UniRu"

# Редактируем конфиг
Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.${ServiceName} configuration files..."
$pathtojson = "C:\Services\${ServiceName}\appsettings.json"
$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

# Правим путь к лог файлу
Write-Host -ForegroundColor Green "[INFO] Change Serilog.WriteTo..."
$json_appsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\${ServiceName}\${ServiceName}-.log"   
    }
}

# Правим настройки Kestrel
Write-Host -ForegroundColor Green "[INFO] Change Kestrel.Endpoints..."
$json_appsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${accKestrelPort}/"
$json_appsetings.Kestrel.Endpoints.Https.Certificate.Subject = "*.bb-webapps.com"

# Правим Origins (домены сайтов, которые используют данный сервис)
Write-Host -ForegroundColor Green "[INFO] Add sites to Origins..."
$Origins = @(
    "https://$($env:COMPUTERNAME).$($defaultDomain):${httpsUniRuPort}"
)
$json_appsetings.Origins = $Origins

# Настройки подключения
Write-Host -ForegroundColor Green "[INFO] Change ConnectionStrings..."
$json_appsetings.ConnectionStrings.UniSiteSettings = "data source=localhost;initial catalog=${uniRuDbName};Integrated Security=SSPI;MultipleActiveResultSets=True;"
$json_appsetings.ConnectionStrings.KernelDb = "data source=localhost;initial catalog=${kernelDbName};Integrated Security=SSPI;MultipleActiveResultSets=True;"
$json_appsetings.ConnectionStrings.Redis = "localhost:6379"
$json_appsetings.ConnectionStrings.RabbitMq = "host=$($env:COMPUTERNAME):5672; username=test; password=test"

ConvertTo-Json $json_appsetings -Depth 4 | Format-Json | Set-Content $pathtojson -Encoding UTF8

$reportVal = @"
[$ServiceName]
$config
	.Serilog.WriteTo| %{ if (_.Name -like 'File'){
			_.Args.path = "C:\Logs\${ServiceName}\${ServiceName}.log" 
		}
    .Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${accKestrelPort}/"
    .Kestrel.EndPoints.Https.Certificate.Subject = "*.bb-webapps.com"
    .Origins = $Origins
    .ConnectionStrings.UniSiteSettings = "data source=localhost;initial catalog=${uniRuDbName};Integrated Security=SSPI;MultipleActiveResultSets=True;"
    .ConnectionStrings.KernelDb = "data source=localhost;initial catalog=${kernelDbName};Integrated Security=SSPI;MultipleActiveResultSets=True;"
    .ConnectionStrings.Redis = "localhost:6379"
    .ConnectionStrings.RabbitMq = "host=$($env:COMPUTERNAME):5672; username=test; password=test"
$('='*60)

"@

Add-Content -force -Path "$($env:WORKSPACE)\$($env:CONFIG_UPDATES)" -value $reportVal -Encoding utf8
