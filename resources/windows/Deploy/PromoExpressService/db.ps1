Import-module '.\scripts\sideFunctions.psm1'

$dbname = "PromoExpressService"
$initScript = 'c:\services\PromoExpressService\init.sql' 

CreateSqlDatabase $dbname
if (test-Path $initScript){
	Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $initScript -ErrorAction continue
}
else{
	write-host "$initScript  not found"
}
