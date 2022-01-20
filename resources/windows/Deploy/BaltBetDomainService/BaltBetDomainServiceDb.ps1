# Создаем БД BaltBetDomain
$dbname = "BaltBetDomain"
$query = "C:\inetpub\BaltBetDomainService\DB\init.sql"
Write-Host -ForegroundColor Green "[INFO] Create database $dbname"
Invoke-sqlcmd -ServerInstance $env:COMPUTERNAME -Query "CREATE DATABASE [$dbname]" -Verbose
# Инициализируем БД BaltBetDomain
Write-Host -ForegroundColor Green "[INFO] Execute DomainService.sql on BaltBetDomain"
Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $query -ErrorAction continue
