Import-module '.\scripts\sideFunctions.psm1'

$dbname = "PromoExpressService"

CreateSqlDatabase $dbname

Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile  'c:\services\PromoExpressService\init.sql' -ErrorAction continue
