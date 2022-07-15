Import-module '.\scripts\sideFunctions.psm1'

###vars
$Dbname =  "UnicomWebRegistration"
$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "C:\Services\UnicomWebRegistration\DB\out\init.bak" 
	}
)


Write-Host -ForegroundColor Green "[INFO] Create and restore db $Dbname"
RestoreSqlDb -db_params $dbs
