# PAY-757
# https://jira.baltbet.ru:8443/browse/PAY-757
# Перевод сервиса PSH на GRPC ASAP

Import-module '.\scripts\sideFunctions.psm1'


$ServiceName = "PaymenSystemHandlers"
$pshKestrelPort = 7149
$kernelGrpcPort = 32419
$defaultDomain = "bb-webapps.com"
$pacThumbprint = $env:PAC_CERT_THUMBPRINT

# Редактируем конфиг
Write-Host -ForegroundColor Green "[INFO] Edit ${ServiceName} configuration files..."
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
$json_appsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${pshKestrelPort}/"
$json_appsetings.Kestrel.Endpoints.Https.Certificate.Subject = "*.bb-webapps.com"

# Правим настройки KernelGrpcOptions
Write-Host -ForegroundColor Green "[INFO] Change KernelGrpcOptions..."
$json_appsetings.KernelGrpcOptions.Url = "http://$($env:COMPUTERNAME).$($defaultDomain):${kernelGrpcPort}/"

# Правим настройки AggregatorAuthOptions
Write-Host -ForegroundColor Green "[INFO] Change AggregatorAuthOptions..."
$json_appsetings.AggregatorAuthOptions.CertificateThumbprint = "$pacThumbprint"
$json_appsetings.AggregatorAuthOptions.ValidOnly = $false


ConvertTo-Json $json_appsetings -Depth 4 | Format-Json | Set-Content $pathtojson -Encoding UTF8
