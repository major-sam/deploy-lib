import-module '.\scripts\sideFunctions.psm1'


$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
## vars
$release_bak_folder = '\\server\tcbuild$\Testers\DB'


$dbs = @(
	@{
		DbName = "MessageService"
		BackupFile = "$release_bak_folder\MessageService.bak" 
        RelocateFiles = @(
			@{
				SourceName = "MessageService"
				FileName = "MessageService.mdf"
			}
			@{
				SourceName = "MessageService_log"
				FileName = "MessageService_log.ldf"
			}
        )      
	}
)
###restore DB
RestoreSqlDb -db_params $dbs
Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.messageservice configuration files..."
$pathtojson = "C:\Services\PersonalInfoCenter\MessageService\appsettings.json"
$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$json_appsetings.Serilog.WriteTo| %{ if ($_.Name -like 'File'){
	$_.Args.path = "C:\logs\PersonalInfoCenter\MessageService-{Date}.log"   }
}
$json_appsetings.RabbitMqConnection.Host ="$shortRabbitStr; publisherConfirms=true; timeout=100; requestedHeartbeat=0"
$json_appsetings.ConnectionStrings.Redis = $shortRedisStr
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8


