Import-module '.\scripts\sideFunctions.psm1'

# Создаем БД Antifraud
$dbName = "Antifraud"
$dbInitBackup = "init.bak"

Write-Host -ForegroundColor Green "[INFO] Create DB $dbName"
CreateSqlDatabase $dbName

Write-Host -ForegroundColor Green "[INFO] Restore $dbInitBackup on $dbName"
Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbName -InputFile  "C:\Services\Payments\Antifraud\AntiFraudDB\out\${dbInitBackup}" -ErrorAction continue
