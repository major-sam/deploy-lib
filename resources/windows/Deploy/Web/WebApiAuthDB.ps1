Import-module '.\scripts\sideFunctions.psm1'

###vars
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "\\server\tcbuild`$\Testers\DB\For WebApi"

$Dbname =  "WebApi.Auth"
$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\WebApiAuth.bak" 
        RelocateFiles = @(
			@{
				SourceName = "WebApi.Auth"
				FileName = "WebApi.Auth.mdf"
			}
			@{
				SourceName = "WebApi.Auth_log"
				FileName = "WebApi.Auth_log.ldf"
			}
		)    
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create dbs"
RestoreSqlDb -db_params $dbs


$oldIp = '#VM_IP'
$oldHostname = '#VM_HOSTNAME'
$oldDbname =  "#DB_NAME"
$q = "
UPDATE [#DB_NAME].Settings.Options SET Value = CASE Name
WHEN 'Global.WcfClient.WcfServicesHostAddress' THEN '#VM_IP'
ELSE Value END
"
$query = $q.replace( $oldIp,  $IPAddress).replace( $oldHostname, $env:COMPUTERNAME).replace( $oldDbname , $Dbname)
Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $DbName -query $query -ErrorAction Stop