Import-module '.\scripts\sideFunctions.psm1'

###vars
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "C:\inetpub\ClientWorkPlace\WebAdministrationDB\out"

$Dbname =  "UniAdministration"
$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\init.bak" 
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