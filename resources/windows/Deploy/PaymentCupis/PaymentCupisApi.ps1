Import-module '.\scripts\sideFunctions.psm1'

$pathtojson = "C:\Services\Payments\PaymentCupisService\PaymentCupis.RestApi.Host\appsettings.json"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 | Where-Object -FilterScript { $_.interfaceindex -ne 1 }).IPAddress.trim()
$pacThumbprint = $env:PAC_CERT_THUMBPRINT

$config = Get-Content -Path $pathtojson -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$config.Serilog.WriteTo[1].Args.path = "C:\logs\RestLog\Payment.Cupis-.log"
$config.Kestrel.Endpoints.Http.Url = "http://${IPAddress}:5001"
$config.DbOptions.ConnectionString = "data source=localhost;initial catalog=Cupis.GrpcHost;Integrated Security=true;MultipleActiveResultSets=True;"

# Правим настройки AggregatorAuthOptions
Write-Host -ForegroundColor Green "[INFO] Change AggregatorAuthOptions..."
$config.AggregatorAuthOptions.CertificateThumbprint = "$pacThumbprint"
$config.AggregatorAuthOptions.ValidOnly = $false

ConvertTo-Json $config -Depth 4| Format-Json | Set-Content $pathtojson -Encoding UTF8


