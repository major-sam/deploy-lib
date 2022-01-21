Import-module '.\scripts\sideFunctions.psm1'

# Создаем БД Cupis.GrpcHost
$dbname = "Cupis.GrpcHost"

CreateSqlDatabase $dbname
# Выполняем скрипты миграции
#foreach ($script in (Get-Item -Path $sqlfolder\* -Include "*.sql").FullName | Sort-Object ) {    
#    Write-Host -ForegroundColor Green "[INFO] Execute $script on $dbname"
#    Invoke-Sqlcmd -verbose -QueryTimeout $queryTimeout -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $script -ErrorAction continue
#}

Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile  'c:\services\payments\PaymentCupisService\CupisGrpcDb\init.sql' -ErrorAction continue
