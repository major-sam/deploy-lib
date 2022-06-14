Import-module '.\scripts\sideFunctions.psm1'

$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$query = "
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'PreRegistrationData')
BEGIN
	DROP TABLE dbo.PreRegistrationData;
	PRINT '[INFO] DROP dbo.PreRegistrationData';
END
ELSE
BEGIN
	PRINT '[INFO] Table dbo.PreRegistrationData does not exist, nothing to DROP...OK';
END

"
$queryTimeout = 720

$dbs = @(
	@{
		DbName = "UniRu"
		BackupFile = "C:\inetpub\ClientWorkPlace\DB\init_site.bak"
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create dbs"

RestoreSqlDb -db_params $dbs


Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $dbs[0].DbName -query $query -ErrorAction Stop
Set-Location C:\
