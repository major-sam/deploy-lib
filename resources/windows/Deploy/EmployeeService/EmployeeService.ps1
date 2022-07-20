# ARCHI-378
# https://jira.baltbet.ru:8443/browse/ARCHI-378

Import-module '.\scripts\sideFunctions.psm1'

$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$serviceName = "EmployeeService"
$targetDir = "C:\Services\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5

$esPort = 60679
$dbname = "BaltBetM"
$kernelDbCS = "Server=localhost;Database=${dbname};Trusted_Connection=True;Encrypt=false;"
# Адрес сервиса WebDataService
$webDataUrl = "http://localhost:65011"
# Адрес сервиса Кернела
$kernelAddress = "http://localhost:8081"
$consulToken = "E78EC97B-3A90-4BC1-BE88-1E0A2B49224C"
$defaultDomain = "bb-webapps.com"

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Секция Kestrel
Write-host "[INFO] Change settings for Kestrel"
$jsonAppsetings.Kestrel.EndPoints.Http.Url = "http://$($env:COMPUTERNAME).$($defaultDomain):${esPort}".ToLower()

# Настраиваем секцию ConnectionStrings
Write-host "[INFO] Change settings for ConnectionStrings"
$jsonAppsetings.ConnectionStrings.DBConnectionString = $kernelDbCS
$jsonAppsetings.ConnectionStrings.WebDataUrl = $webDataUrl

# Настраиваем KernelAddress
Write-host "[INFO] Change settings for KernelAddress"
$jsonAppsetings.KernelAddress = $kernelAddress

# Настраиваем секцию Consul
Write-host "[INFO] Change settings for Consul"
$jsonAppsetings.Consul.Token = $consulToken
$jsonAppsetings.Consul.Services[0].ConsulConfig.HostAddress = $IPAddress
$jsonAppsetings.Consul.Services[0].ConsulConfig.Port = $esPort
$jsonAppsetings.Consul.Services[0].ConsulConfig.ServiceName = $serviceName
$jsonAppsetings.Consul.Services[0].ServiceCheckConfig.Address = "http://$($env:COMPUTERNAME).$($defaultDomain):${esPort}/health".ToLower()


ConvertTo-Json $jsonAppsetings -Depth $jsonDepth | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"