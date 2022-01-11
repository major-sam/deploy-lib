import-module '.\scripts\sideFunctions.psm1'

###vars
$targetDir = "C:\inetpub\KRM"
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

$targetDir = 'C:\inetpub\KRM'
$KRMConfig ="$targetDir\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

### edit KRM Web.config
$conf = [Xml](Get-Content $KRMConfig)
$conf.configuration."system.serviceModel".client |% {$_.endpoint |% {$_.address = $_.address.replace("localhost",$CurrentIpAddr)}}
$conf.Save($KRMConfig)
