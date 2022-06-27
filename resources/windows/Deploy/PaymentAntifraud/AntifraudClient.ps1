Import-module '.\scripts\sideFunctions.psm1'

$serviceName = "Client"
$targetDir = "C:\Services\Payments\Antifraud\${ServiceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5

$httpsAFServicePort = 7157
$httpsAFClientPort = 7279
$defaultDomain = "bb-webapps.com"

# LDAP settings
$ldapHost = "gkbaltbet.local"
$baseDN = "DC=gkbaltbet,DC=local"
$userQuery = "(`&(objectClass=user)(sAMAccountName={0}))"
$accessGroupNames = @(
    "CN=devops_testers,OU=ГРУППЫ,OU=GKBALTBET,DC=gkbaltbet,DC=local",
    "CN=devops_dev,OU=ГРУППЫ,OU=GKBALTBET,DC=gkbaltbet,DC=local",
    "CN=devops_,OU=ГРУППЫ,OU=GKBALTBET,DC=gkbaltbet,DC=local"
)

Write-host "[INFO] Start Antifraud${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json

# Настраиваем секцию логирования
$jsonAppsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\Payments\Antifraud\Antifraud.Client-.log"
    }
}

# Настраиваем секцию Kestrel
$jsonAppsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):$httpsAFClientPort"
$jsonAppsetings.Kestrel.Endpoints.Https.Certificate.Subject = "*.bb-webapps.com"

# Настраиваем секцию подключения к AntifraudService
$jsonAppsetings.ConnectionStrings.AntifraudService = "https://$($env:COMPUTERNAME).$($defaultDomain):$httpsAFServicePort"

# Настраиваем секцию LdapOptions
$jsonAppsetings.LdapOptions.Host = $ldapHost
$jsonAppsetings.LdapOptions.BaseDns = $baseDN
$jsonAppsetings.LdapOptions.UserQuery = $userQuery

# Настраиваем секцию AuthOptions
$jsonAppsetings.AuthOptions.ServiceAccessGroupNames = $accessGroupNames

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"