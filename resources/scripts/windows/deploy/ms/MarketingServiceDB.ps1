import-module '.\scripts\sideFunctions.psm1'
$dbname = 'MarketingDB'
CreateSqlDatabase ($dbname)
Invoke-Sqlcmd -Database $dbname -InputFile 'c:\services\Marketing\DB\DeployDB.sql'
Invoke-Sqlcmd -Database $dbname -InputFile 'c:\services\Marketing\DB\InitDb.sql'
