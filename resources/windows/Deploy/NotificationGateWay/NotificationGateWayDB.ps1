Import-module '.\scripts\sideFunctions.psm1'

$release_bak_folder = "C:\Services\NotificationGateWay\DB"

$Dbname =  "BaltBet.SmsService.Db"
$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\init.bak" 
        RelocateFiles = @(
			@{
				SourceName = "BaltBet.SmsService.Db"
				FileName = "BaltBet.SmsService.Db.mdf"
			}
			@{
				SourceName = "BaltBet.SmsService.Db_log"
				FileName = "BaltBet.SmsService.Db_log.ldf"
			}
		)    
	}
)

Write-Host -ForegroundColor Green "[INFO] Create and restore db $Dbname"
RestoreSqlDb($dbs)