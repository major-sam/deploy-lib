Import-module '.\scripts\sideFunctions.psm1'

$Dbname =  "AuthService"
###vars
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "C:\Services\UniAuthService\DB"

$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\init.bak" 
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create and restore db $Dbname"
RestoreSqlDb -db_params $dbs
Set-Location C:\
