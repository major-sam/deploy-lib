Import-module '.\scripts\sideFunctions.psm1'
$ServiceName = "CoefService"
$ServiceFolderPath = "C:\Services\${ServiceName}"
$DataBase = "BaltBetMMirror"

$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

Write-Host "[INFO] Edit BaltBet.CoefService configuration files..."
$config = Get-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$config.Settings.DataBase = "data source=localhost;initial catalog=${DataBase};Integrated Security=true;MultipleActiveResultSets=True;"
$config.Serilog.WriteTo|% {
	if ($_.Name -like 'File'){
		if ("pathFormat" -in $_.Args.ContainsKey.PSObject.Properties.Name){
			$_.Args.pathFormat	= "C:\logs\CoefService\CoefService-{Date}.log"
		}

		if ("path" -in $_.Args.ContainsKey.PSObject.Properties.Name){
			$_.Args.path = "C:\logs\CoefService\CoefService-{Date}.log"
		}
	}
}
$config.Settings.RabbitMq = "$shortRabbitStr;publisherConfirms=true; timeout=100; requestedHeartbeat=0"

ConvertTo-Json $config -Depth 4  | Format-Json | Set-Content "$ServiceFolderPath\appsettings.json" -Encoding UTF8
