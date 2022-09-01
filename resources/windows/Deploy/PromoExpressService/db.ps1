Import-module '.\scripts\sideFunctions.psm1'

$dbname = "PromoExpressService"
$serviceFolder = "c:\services\$($dbname)" 
$initScript = "$($serviceFolder)\init.sql'"

CreateSqlDatabase $dbname
if (test-Path $initScript){
	Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $initScript -ErrorAction continue
}
else{
	$dbs = @(
		@{
			DbName = $dbname
			BackupFile = "$($serviceFolder)\$($dbname)Db\init.bak"
		}
	)
	Write-Host -ForegroundColor Green "[INFO] Create dbs"
	RestoreSqlDb -db_params $dbs
}
