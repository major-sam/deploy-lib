<#
Хостится как приложение в IIS https:8004
Необходимо создать БД BaltBetDomain
Настроить ConnectionStrings
#>


Write-Host -ForegroundColor Green "In progress..."

# Редактируем конфиг
$ServiceName = "BaltBetDomainService"
$ServiceFolderPath = "C:\inetpub\${ServiceName}"
$dbname = "BaltBetDomain"
$queryTimeout = 720
$file = "$($env:workspace)\scripts\deploy\DomainService.sql"

$CSDomainDb = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=$dbname"
$CSKernelDb = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=BaltBetM"


Write-Host -ForegroundColor Green "[INFO] Edit BaltBetDomainService configuration files..."
$config = Get-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$config.ConnectionStrings.DomainDb = $CSDomainDb
$config.ConnectionStrings.KernelDb = $CSKernelDb
Set-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8 -Value ($config | ConvertTo-Json -Depth 100)

# Создаем БД BaltBetDomain
Write-Host -ForegroundColor Green "[INFO] Create database $dbname"
Invoke-sqlcmd -ServerInstance $env:COMPUTERNAME -Query "CREATE DATABASE [$dbname]" -Verbose

# Инициализируем БД BaltBetDomain
Write-Host -ForegroundColor Green "[INFO] Execute DomainService.sql on $dbname"
Invoke-Sqlcmd -verbose -QueryTimeout $queryTimeout -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $file -ErrorAction continue