<#
WidgetService (хостим в IIS https:6001, доступен swagger)
#>

Import-module '.\scripts\sideFunctions.psm1'

$rabbitpasswd = $env:RABBIT_CREDS_PSW 
$shortRabbitStr = "host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$serviceName = "BaltWidgetsService"
$targetDir = "C:\Services\BaltWidgets\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$httpWSPort = 6000
$httpsWSPort = 6001
$defaultDomain = "bb-webapps.com"

if (Test-path($pathtojson)) {
    Write-host "[INFO] Start ${serviceName} deploy script"
    Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
    $jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

    # Настраиваем секцию подключения к Rabbit
    $jsonAppsetings.ConnectionStrings.ParserRabbit = "$shortRabbitStr"
    $jsonAppsetings.ConsumerService.SubscriptionId = "WidgetConsumer-$($env:COMPUTERNAME)"

    # Настраиваем секцию DataConfiguration
    try { $jsonAppsetings.DataConfiguration.UseSwagger = $true } 
    catch { Write-host "[WARN] UseSwagger option doesn't exist" }

    # Настраиваем секцию Kestrel
    $jsonAppsetings.Kestrel.Endpoints.Http.Url = "http://$($env:COMPUTERNAME).$($defaultDomain):${httpWSPort}"
    $jsonAppsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):${httpsWSPort}"
    $jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Store = "My"
    $jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Location = "LocalMachine"
    $jsonAppsetings.Kestrel.EndPoints.Https.Certificate.Subject = "*.bb-webapps.com"
    $jsonAppsetings.Kestrel.EndPoints.Https.Certificate.AllowInvalid = $false

    # Настраиваем секцию логирования
    $jsonAppsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
            $_.Args.path = "C:\Logs\BaltWidgets\${serviceName}\Widget.Service.log"  
            $_.Args.restrictedToMinimumLevel = "Information" 
        }
    }

    ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
    Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"
}
else {
    Write-host "[INFO] $pathtojson does not exist. Skip deploy $serviceName."
}
