# PAY-757
# https://jira.baltbet.ru:8443/browse/PAY-757
# Перевод сервиса PSH на GRPC ASAP

Import-module '.\scripts\sideFunctions.psm1'


$ServiceName = "PaymenSystemHandlers"
$pshHttpPort = 88
$pshHttpsPort = 89
$kernelGrpcPort = 32419
$defaultDomain = "bb-webapps.com"
$pacThumbprint = $env:PAC_CERT_THUMBPRINT

$url = "{
    'Url': 'http://+:88'        
}" | ConvertFrom-Json

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
$json_appsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${pshHttpsPort}"
$json_appsetings.Kestrel.Endpoints.Https.Certificate.Subject = "*.bb-webapps.com"
$json_appsetings.Kestrel.Endpoints | Add-Member -NotePropertyValue $url -NotePropertyName "Http"
$json_appsetings.Kestrel.Endpoints.Http.Url = "http://+:${pshHttpPort}"

# Правим настройки KernelGrpcOptions
Write-Host -ForegroundColor Green "[INFO] Change KernelGrpcOptions..."
$json_appsetings.KernelGrpcOptions.Url = "http://localhost:${kernelGrpcPort}"

# Правим настройки AggregatorAuthOptions
Write-Host -ForegroundColor Green "[INFO] Change AggregatorAuthOptions..."
$json_appsetings.AggregatorAuthOptions.CertificateThumbprint = "$pacThumbprint"
$json_appsetings.AggregatorAuthOptions.ValidOnly = $false


ConvertTo-Json $json_appsetings -Depth 4 | Format-Json | Set-Content $pathtojson -Encoding UTF8
