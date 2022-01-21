# Создаем БД CupisIntegrationService
$file = "C:\Services\CupisIntegrationService\DB\init.sql"
$dbname = "CupisIntegrationService"

Write-Host -ForegroundColor Green "[INFO] Create database $dbname"
Invoke-sqlcmd -ServerInstance $env:COMPUTERNAME -Query "CREATE DATABASE [$dbname]" -Verbose

# Выполняем инит скрипт на БД CupisIntegrationService
Write-Host -ForegroundColor Green "[INFO] Execute $file on $dbname"
Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $file -ErrorAction continue

