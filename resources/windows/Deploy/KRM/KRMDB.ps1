import-module '.\scripts\sideFunctions.psm1'

###vars
$ProgressPreference = 'SilentlyContinue'
$release_bak_folder= "\\server\tcbuild$\Testers\DB"

$dbs = @(
	@{
		DbName = "CWS_ScreenSaversTempDB"
		BackupFile = "$release_bak_folder\CWS_ScreenSaversTempDB.bak"
		RelocateFiles = @(
			@{
				SourceName = "CWS_ScreenSaversTempDB"
				FileName = "CWS_ScreenSaversTempDB.mdf"
			}
			@{
				SourceName = "CWS_ScreenSaversTempDB_log"
				FileName = "CWS_ScreenSaversTempDB_log.ldf"
			}
		)
	}
)
RestoreSqlDb -db_params $dbs
