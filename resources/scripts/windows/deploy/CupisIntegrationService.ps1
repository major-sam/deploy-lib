Import-module '.\scripts\sideFunctions.psm1'
<#
    CupisIntegrationService
    Скрипт для разворота CupisIntegrationService
    Разворачивается в IIS
    Порт :4453
    c:\services\CupisIntegrationService\BaltBet.CupisIntegrationService.Host\

    Конфиг: appsettings.json
#>


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

$config = Get-Content "${ServiceFolderPath}\appsettings.json" -Encoding utf8 | ConvertFrom-Json
$config.Cupis.BaseUrl = $CupisBaseUrl
$config.Cupis.BackupBaseUrl = $CupisBackupBaseUrl
#$config.Cupis.CertPassword = $CupisCertPassword
$config.Cupis.CertThumbprint = $CupisCertThumbprint
$config.Bus.CupisCallbackBusConnectionString = "host=localhost"
$config.Fns.BaseUrl = $FnsBaseUrl
$config.Fns.Key = $FnsKey
$config.VirtualMachines.EnableMultiNotification = "false"
$config.DocumentImages.UploadServiceAddress = "http://localhost:8123"
$config.Authorization.Realm = "https://vm4-p0.bb-webapps.com:4453/"

$config.Bus.CupisCallbackBusConnectionString = "host=$($env:COMPUTERNAME);username=test;password=test"


ConvertTo-Json $config -Depth 4  | Format-Json | Set-Content "$ServiceFolderPath\appsettings.json" -Encoding UTF8
# Создаем БД CupisIntegrationService
$queryTimeout = 720
$file = "C:\Services\CupisIntegrationService\DB\init.sql"
$dbname = "CupisIntegrationService"

Write-Host -ForegroundColor Green "[INFO] Create database $dbname"
Invoke-sqlcmd -ServerInstance $env:COMPUTERNAME -Query "CREATE DATABASE [$dbname]" -Verbose

# Выполняем инит скрипт на БД CupisIntegrationService
Write-Host -ForegroundColor Green "[INFO] Execute $file on $dbname"
Invoke-Sqlcmd -verbose -QueryTimeout $queryTimeout -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $file -ErrorAction continue


<#
    BaltBet.CupisIntegrationService.GrpcHost
    Скрипт для разворота BaltBet.CupisIntegrationService.GrpcHost.
    c:\Services\CupisIntegrationService\BaltBet.CupisIntegrationService.GrpcHost\

    Конфиг: appsettings.json

    ARCHI-238
    Дополнительно нужный правки в Web.config сайтов "UniRu" (сделать в post/UniRu.ps1 )
    <Grpc>
        <Services>
            <add name="CupisIntegrationService" host="localhost" port="5010" maxpoolchannelcount="10"/>
        </Services>
    </Grpc>
#>


$ServiceName = "BaltBet.CupisIntegrationService.GrpcHost"
$ServiceFolderPath = "C:\Services\CupisIntegrationService\${ServiceName}"

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
