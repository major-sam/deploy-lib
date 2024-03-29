Import-module '.\scripts\sideFunctions.psm1'

$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

Write-Host "[INFO] Check if 'env:Zone' exists"
if(Test-Path 'env:Zone') {
	$zone = $env:Zone
	$zonePath = $env:Zonepath
	$dbName = "Uni${zone}"
	$backupFile = "${zonePath}"
	Write-Host "[INFO] Zone: ${zone}, Path: ${zonePath}, DB: $dbName, Backup: $backupFile"
} else {
	Write-Host "[INFO] 'env:Zone' does not exist. Set default zone RU."
	$zone = "Ru"
	$dbName = "Uni${zone}"
	$backupFile = "C:\inetpub\ClientWorkPlace"
	Write-Host "[INFO] DB = $dbName, backup $backupFile"
}

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
		DbName = "${dbName}"
		BackupFile = "${backupFile}\DB\init_site.bak"
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create dbs"

RestoreSqlDb -db_params $dbs


Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $dbs[0].DbName -query $query -ErrorAction Stop
Set-Location C:\
