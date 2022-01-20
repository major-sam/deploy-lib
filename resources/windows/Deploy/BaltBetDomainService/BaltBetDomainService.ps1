<#
Хостится как приложение в IIS https:8004
Необходимо создать БД BaltBetDomain
Настроить ConnectionStrings
#>


Write-Host -ForegroundColor Green "In progress..."

# Редактируем конфиг
$ServiceName = "BaltBetDomainService"
$ServiceFolderPath = "C:\inetpub\${ServiceName}\${ServiceName}"
$dbname = "BaltBetDomain"
$CSDomainDb = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=$dbname"
$CSKernelDb = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=BaltBetM"


Write-Host -ForegroundColor Green "[INFO] Edit BaltBetDomainService configuration files..."
$config = Get-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$config.ConnectionStrings.DomainDb = $CSDomainDb
$config.ConnectionStrings.KernelDb = $CSKernelDb
Set-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8 -Value ($config | ConvertTo-Json -Depth 100)


