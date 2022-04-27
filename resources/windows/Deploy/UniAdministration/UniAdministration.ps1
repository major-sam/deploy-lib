# UNICOM-218
# https://jira.baltbet.ru:8443/browse/UNICOM-218
# Админ панель Uni выносится в отдельный компонент "uni.com"


Import-module '.\scripts\sideFunctions.psm1'

$serviceName = "UniAdministration"
$targetDir = "C:\inetpub\ClientWorkPlace\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$dbname = "UniAdministration"

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Настраиваем секцию подключения к БД
$jsonAppsetings.ConnectionStrings.DataContext = "data source=localhost;initial catalog=${dbname};Integrated Security=true;MultipleActiveResultSets=True;"

# Настраиваем адрес корневого каталога для CKFinder
(($jsonAppsetings.ckfinder.backends | where { $_.name -ilike "default" }).options | where {
    $_.name -ilike 'root' }).value = 'c:\inetpub\images'

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"