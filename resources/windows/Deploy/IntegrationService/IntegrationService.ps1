# ARCHI-378
# https://jira.baltbet.ru:8443/browse/ARCHI-378

Import-module '.\scripts\sideFunctions.psm1'

$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$serviceName = "IntegrationService"
$targetDir = "C:\Services\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$webConfig = "$targetDir\IntegrationService.exe.config"

$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$isPort = 65011
$1Cuser = "User"
$1Cpsw = "Password"
$serviceUrl = "http://localhost:${isPort}"

$emailServerAddress = "127.0.0.1"
$emailServerPort = "25"
$emailServeUser = "User"
$emailServePassword = "Password"

$consulToken = "E78EC97B-3A90-4BC1-BE88-1E0A2B49224C"
$defaultDomain = "bb-webapps.com"

Write-host "[INFO] Start ${serviceName} deploy script"

######################################################
############# Редактирование appsettings #############
######################################################
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Секция Kestrel
Write-host "[INFO] Change settings for Kestrel"
$jsonAppsetings.Kestrel.EndPoints.Http.Url = "http://$($env:COMPUTERNAME).$($defaultDomain):${isPort}".ToLower()

# Настраиваем секцию Consul
Write-host "[INFO] Change settings for Consul"
$jsonAppsetings.Consul.Token = $consulToken
$jsonAppsetings.Consul.Services[0].ConsulConfig.HostAddress = $IPAddress
$jsonAppsetings.Consul.Services[0].ConsulConfig.Port = $isPort
$jsonAppsetings.Consul.Services[0].ConsulConfig.ServiceName = $serviceName
$jsonAppsetings.Consul.Services[0].ServiceCheckConfig.Address = "http://$($env:COMPUTERNAME).$($defaultDomain):${isPort}/health".ToLower()


ConvertTo-Json $jsonAppsetings -Depth $jsonDepth | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"

######################################################
#### Редактирование IntegrationService.exe.config ####
######################################################

Write-Host -ForegroundColor Green "[INFO] Edit $webConfig"
$webdoc = [Xml](Get-Content $webConfig)

# Настройки подключения к RabbitMQ
$webdoc.configuration.applicationSettings.'IntegrationService.Properties.QueueSettings'.setting  | % {
    if($_.Name -eq "ConnectionString"){
        $_.value = $shortRabbitStr
    }
}
# Настройки подключения к web-сервису 1С
$webdoc.configuration.applicationSettings.'IntegrationService.Properties.Exchange'.setting | % {
    if($_.Name -eq "UserName"){
        $_.value = $1Cuser
    }
    if($_.Name -eq "Password"){
        $_.value = $1Cpsw
    }
    if($_.Name -eq "Url"){
        $_.value = $serviceUrl
    }
}

# Настройки подключения к email серверу
$webdoc.configuration.email.Servers.add | % {
    $_.Address = $emailServerAddress
    $_.Port = $emailServerPort
    $_.Login = $emailServeUser
    $_.Password = $emailServePassword
}

$webdoc.Save($webConfig)

Write-Host -ForegroundColor Green "[INFO] Done!"
