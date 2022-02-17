Import-module '.\scripts\sideFunctions.psm1'
<#
    CupisIntegrationService
    Скрипт для разворота CupisIntegrationService
    Разворачивается в IIS
    Порт :4453
    c:\services\CupisIntegrationService\BaltBet.CupisIntegrationService.Host\

    Конфиг: appsettings.json
#>


$ServiceName = "BaltBet.CupisIntegrationService.GrpcHost"
$ServiceFolderPath = "C:\Services\CupisIntegrationService\${ServiceName}"
if (test-path $ServiceFolderPath){
    Write-Host 'LEGACY GRPC HOST'
}
else{
    exit 0
}

# Редактируем конфиг
Write-Host -ForegroundColor Green "[INFO] Print BaltBet.CupisIntegrationService.GrpcHost configuration files..."
Get-Content -Encoding UTF8 -Path "${ServiceFolderPath}\appsettings.json"

$CupisBaseUrl = "https://demo-api.1cupis.ru/binding-api/"
$CupisBackupBaseUrl = "https://demo-api.1cupis.ru/"
#$CupisCertPassword = $env:CUPIS_CERT_PASS
$CupisCertThumbprint = $env:CUPIS_CERT_THUMBPRINT
$FnsBaseUrl = "https://api-fns.ru/api/"
$FnsKey = $env:CUPIS_FNS_KEY


$config = Get-Content "${ServiceFolderPath}\appsettings.json" -Encoding utf8 | ConvertFrom-Json
$config.Cupis.BaseUrl = $CupisBaseUrl
$config.Cupis.BackupBaseUrl = $CupisBackupBaseUrl
#$config.Cupis.CertPassword = $CupisCertPassword
$config.Cupis.CertThumbprint = $CupisCertThumbprint
$config.Fns.BaseUrl = $FnsBaseUrl
$config.Fns.Key = $FnsKey


ConvertTo-Json $config -Depth 5| Format-Json | Set-Content "${ServiceFolderPath}\appsettings.json" -Encoding utf8

$reportVal =@"
[$ServiceName]
$ServiceFolderPath\appsettings.json
    .Cupis.BaseUrl = $CupisBaseUrl
    .Cupis.BackupBaseUrl = $CupisBackupBaseUrl
    .Cupis.CertPassword = $CupisCertPassword
    .Cupis.CertThumbprint = $CupisCertThumbprint
    .Fns.BaseUrl = $FnsBaseUrl
    .Fns.Key = $FnsKey
$('='*60)

"@

Add-Content -force -Path "$($env:WORKSPACE)\$($env:CONFIG_UPDATES)" -value $reportVal -Encoding utf8
