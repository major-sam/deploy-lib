Import-module '.\scripts\sideFunctions.psm1'
<#
    CupisIntegrationService
    Скрипт для разворота CupisIntegrationService
    Разворачивается в IIS
    Порт :4453
    c:\services\CupisIntegrationService\BaltBet.CupisIntegrationService.Host\

    Конфиг: appsettings.json
#>

$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$ServiceName = "BaltBet.CupisIntegrationService.Host"
$ServiceFolderPath = "C:\Services\CupisIntegrationService\${ServiceName}"


# Редактируем конфиг
Write-Host -ForegroundColor Green "[INFO] Print CupisIntegrationService configuration files..."
Get-Content -Encoding UTF8 -Path "${ServiceFolderPath}\appsettings.json"

$CupisBaseUrl = "https://demo-api.1cupis.ru/binding-api/"
$CupisBackupBaseUrl = "https://demo-api.1cupis.ru/"
#$CupisCertPassword = $env:CUPIS_CERT_PASS
$CupisCertThumbprint = $env:CUPIS_CERT_THUMBPRINT
$FnsBaseUrl = "https://api-fns.ru/api/"
$FnsKey = $env:CUPIS_FNS_KEY
$cisHttpsPort = 4453
$cisGrpcPort = 5010
$idsHttpPort = 8123
$defaultDomain = "bb-webapps.com"

$config = Get-Content "${ServiceFolderPath}\appsettings.json" -Encoding utf8 | ConvertFrom-Json
$config.Cupis.BaseUrl = $CupisBaseUrl
$config.Cupis.BackupBaseUrl = $CupisBackupBaseUrl
#$config.Cupis.CertPassword = $CupisCertPassword
$config.Cupis.CertThumbprint = $CupisCertThumbprint
$config.Bus.CupisCallbackBusConnectionString = "host=localhost"
$config.Fns.BaseUrl = $FnsBaseUrl
$config.Fns.Key = $FnsKey
$config.Fns.UseFakeRequest = "true"
$config.VirtualMachines.EnableMultiNotification = "false"
if($config.VirtualMachines.EnableMonitor) {
    $config.VirtualMachines.EnableMonitor = "true"
} else {
    Write-Host "[INFO] VirtualMachines.EnableMonitor setting does not exist"
}
$config.DocumentImages.UploadServiceAddress = "http://localhost:${idsHttpPort}"
$config.Authorization.Realm = "https://vm4-p0.bb-webapps.com:${cisHttpsPort}/"

$config.Bus.CupisCallbackBusConnectionString = "host=$($env:COMPUTERNAME);username=test;password=test"

$config.Kestrel.EndPoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${cisHttpsPort}"
$config.Kestrel.EndPoints.Https.Certificate.Subject = "*.bb-webapps.com"
$config.Kestrel.EndPoints.Https.Certificate.Store = "My"
$config.Kestrel.EndPoints.Https.Certificate.AllowInvalid = "true"
$config.Bus.CupisCallbackBusConnectionString=$shortRabbitStr
$config.VirtualMachines.LocalMachineBusAddress=$shortRabbitStr

$config.Kestrel.EndPoints.gRPC.Url = "http://localhost:${cisGrpcPort}"

ConvertTo-Json $config -Depth 4  | Format-Json | Set-Content "$ServiceFolderPath\appsettings.json" -Encoding UTF8

