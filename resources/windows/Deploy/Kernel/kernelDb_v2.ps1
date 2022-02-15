import-module '.\scripts\sideFunctions.psm1'

$ProgressPreference = 'SilentlyContinue'
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$queryTimeout = 720
$dbs = @(
	@{
		DbName = "BaltBetM"
		BackupFile = "\\server\tcbuild$\Testers\DB\_jenkins\BaltbetM.bak"
	}
	@{
		DbName = "BaltBetMMirror"
		BackupFile = "\\server\tcbuild$\Testers\DB\_jenkins\BaltbetM.bak"
	}
	@{
		DbName = "BaltBetWeb"
		BackupFile = "\\server\tcbuild$\Testers\DB\_jenkins\BaltbetWeb.bak"
	}
)
Write-Host -ForegroundColor Green "[INFO] Create dbs"

RestoreSqlDb -db_params $dbs

# Выполняем скрипты из актуализации BaltBetM
$qwr="
	ALTER DATABASE BaltBetM
	COLLATE Cyrillic_General_CI_AS
	GO
	"
Invoke-Sqlcmd -Verbose -ServerInstance $env:COMPUTERNAME -Query $qwr -ErrorAction continue

