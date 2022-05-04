
Import-module '.\scripts\sideFunctions.psm1'

###vars
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "C:\Services\Payments\Antifraud\AntifraudDB\out"

$Dbname =  "Antifraud"
$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\init.bak" 
        RelocateFiles = @(
			@{
				SourceName = "Antifraud"
				FileName = "Antifraud.mdf"
			}
			@{
				SourceName = "Antifraud_log"
				FileName = "Antifraud_log.ldf"
			}
		)    
	}
)

### Create dbs
Write-Host -ForegroundColor Green "[INFO] Create and restore db $Dbname"
RestoreSqlDb -db_params $dbs

### PAY-725
$query = "
INSERT INTO Configurations (IsActive, OptionsJson) VALUES (1, N'{ 'mainOptions': { 'isEnabled': true, 'strategy': 1 }, 'failedPaymentsTrigger': { 'isEnabled': true, 'invoiceNumber': 5, 'periodDays': 10, 'percentFailed': 50 } }');
GO
"
Write-Host -ForegroundColor Green "[INFO] Execute query PAY-725 on db $Dbname"
Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $Dbname -query $query -ErrorAction Stop
###