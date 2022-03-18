Import-module '.\scripts\sideFunctions.psm1'

###vars
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "\\server\tcbuild`$\Testers\DB\For WebApi"

$Dbname =  "AuthService"
$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\WebApiAuth.bak" 
        RelocateFiles = @(
			@{
				SourceName = "AuthService"
				FileName = "AuthService.mdf"
			}
			@{
				SourceName = "AuthService_log"
				FileName = "AuthService_log.ldf"
			}
		)    
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create dbs $Dbname"
RestoreSqlDb -db_params $dbs


$oldIp = '#VM_IP'
$oldHostname = '#VM_HOSTNAME'
$oldDbname =  "#DB_NAME"
$q = "
UPDATE [#DB_NAME].Settings.Options SET Value = CASE Name
WHEN 'Global.WcfClient.WcfServicesHostAddress' THEN '#VM_IP'
ELSE Value END
"
# Содержимое из скрипта по задаче ARCHI-225
$q225 = "
DROP TABLE [dbo].[__EFMigrationsHistory]
GO

DROP TABLE [Auth].[__EFMigrationsHistory]
GO

DROP TABLE [Settings].[Options]
GO

DROP TABLE [Settings].[OptionsGroups]
GO

DROP INDEX [IX_AuthenticatedAccounts_RefreshToken] ON [Auth].[AuthenticatedAccounts]
GO

ALTER TABLE [Auth].[AuthenticatedAccounts] ALTER COLUMN [RefreshToken] NVARCHAR (MAX) NULL
GO
"

$query = $q.replace( $oldIp,  $IPAddress).replace( $oldHostname, $env:COMPUTERNAME).replace( $oldDbname , $Dbname)
Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $DbName -query $query -ErrorAction Stop

Write-Host -ForegroundColor Green "[INFO] Execute sql script from task ARCHI-225 on $Dbname"
Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $DbName -query $q225 -ErrorAction Continue