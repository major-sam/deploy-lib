Import-module '.\scripts\sideFunctions.psm1'

$ProgressPreference = 'SilentlyContinue'

$Dbname =  "EraiDB"
$release_bak_folder = "C:\Services\ERAI\EraiServiceDb"

$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\init.bak" 
	}
)

###Create and resore dbs
Write-Host -ForegroundColor Green "[INFO] Create and restore db $Dbname"
RestoreSqlDb -db_params $dbs
Set-Location C:\