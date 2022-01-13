import-module '.\scripts\sideFunctions.psm1'

$ProgressPreference = 'SilentlyContinue'
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$db = (@{
	DbName = "SiteCom"
	BackupFile = "\\server\tcbuild$\Testers\DB\SiteCom.bak"
	RelocateFiles = @(
			@{
				SourceName = "SiteCom"
				FileName = "SiteCom.mdf"
			}
			@{
				SourceName = "SiteCom_log"
				FileName = "SiteCom.ldf"
			}
		)
	})
RestoreSqlDb -db_params $db
