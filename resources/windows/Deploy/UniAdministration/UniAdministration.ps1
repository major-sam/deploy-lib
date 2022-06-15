# ARCHI-412
# https://jira.baltbet.ru:8443/browse/ARCHI-412
# Админ панель Uni с авторизацией через LDAP


Import-module '.\scripts\sideFunctions.psm1'

$serviceName = "UniAdministration"
$targetDir = "C:\Services\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$dbname = "UniAdministration"

$ldapHost = "gkbaltbet.local:389"
$baseDN = "OU=Технические,OU=Santorin,OU=GKBALTBET,DC=gkbaltbet,DC=local"
$contentGroup = "Webtest-Content"
$contentViewGroup = "Webtest-ContentView"
$settingsViewGroup = "Webtest-SettingsView"
$adminGroup = "Webtest-Admin"


Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Настраиваем секцию подключения к БД
Write-host "[INFO] Change settings for ConnectionStrings.DataContext"
$jsonAppsetings.ConnectionStrings.DataContext = "data source=localhost;initial catalog=${dbname};Integrated Security=true;MultipleActiveResultSets=True;"

# Настраиваем секцию authentication
Write-host "[INFO] Change settings for authentication.ldapAccess"
$jsonAppsetings.authentication.ldapAccess.host = $ldapHost
$jsonAppsetings.authentication.ldapAccess.distinguishedName = $baseDN
Write-host "[INFO] Change settings for authentication.groups"
$jsonAppsetings.authentication.groups.contentGroup = $contentGroup
$jsonAppsetings.authentication.groups.contentViewGroup = $contentViewGroup
$jsonAppsetings.authentication.groups.settingsViewGroup = $settingsViewGroup
$jsonAppsetings.authentication.groups.adminGroup = $adminGroup

# Настраиваем адрес корневого каталога для CKFinder
(($jsonAppsetings.ckfinder.backends | Where-Object { $_.name -ilike "default" }).options | Where-Object {
    $_.name -ilike 'root' }).value = 'c:\inetpub\images'

# Настраиваем секцию логирования
$jsonAppsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\${serviceName}\${serviceName}-.txt" 
        $_.Args.restrictedToMinimumLevel = "Warning" 
    }
}

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"