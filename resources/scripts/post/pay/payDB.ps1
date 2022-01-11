import-module '.\scripts\sideFunctions.psm1'
$dbname = 'BalancingDb'
CreateSqlDatabase ($dbname)
Invoke-Sqlcmd -Database $dbname -InputFile 'C:\Services\Payments\PaymentBalancing\BaltBet.Payment.BalancingModel\init.sql'
