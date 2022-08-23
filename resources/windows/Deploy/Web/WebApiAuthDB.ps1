Import-module '.\scripts\sideFunctions.psm1'

###vars
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$redispasswd = $ENV:REDIS_CREDS_PSW
$shortRedisStr="$($env:REDIS_HOST),password=$redispasswd"
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
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


$query = "
UPDATE [$($dbname)].Settings.Options SET Value = CASE Name
WHEN 'Global.WcfClient.WcfServicesHostAddress' THEN '$($IPAddress)'
WHEN 'Global.KernelRedisConnectionString' THEN '$($shortRedisStr),syncTimeout=1000,allowAdmin=True,connectTimeout=10000,ssl=False,abortConnect=False,connectRetry=10,proxy=None'
ELSE Value END

"
Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $DbName -query $query -ErrorAction Stop
