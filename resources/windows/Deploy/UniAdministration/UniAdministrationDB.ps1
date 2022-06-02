Import-module '.\scripts\sideFunctions.psm1'

###vars
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "\\server\tcbuild$\Testers\DB"

$Dbname =  "UniAdministration"
$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\UniAdministration_empty.bak" 
        RelocateFiles = @(
			@{
				SourceName = $Dbname
				FileName = "${Dbname}.mdf"
			}
			@{
				SourceName = "${Dbname}_log"
				FileName = "${Dbname}_log.ldf"
			}
		)    
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create and restore db $Dbname"
RestoreSqlDb -db_params $dbs