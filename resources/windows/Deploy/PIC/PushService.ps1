import-module '.\scripts\sideFunctions.psm1'
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)"
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$config = 	"C:\Services\PersonalInfoCenter\PushService\Log.config"
if (test-path $config){
        $svc = get-item $config
        $webdoc = [Xml](Get-Content $svc.Fullname)
        $webdoc.log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
        $webdoc.Save($svc.Fullname)
}
else{write-host  $config ' not exists'        }

$file ="C:\Services\PersonalInfoCenter\PushServiceDB\init.sql"
$backup ="C:\Services\PersonalInfoCenter\PushServiceDB\init.bak"
if (test-path $file){
        CreateSqlDatabase ("PushService")
        Invoke-Sqlcmd -ServerInstance $env:COMPUTERNAME -Database "PushService" -InputFile $file -Verbose
}
elseif (test-path $backup){
        $dbs = @(
                        @{
                        DbName = "PushService"
                        BackupFile = $backup
                        }
                )
Write-Host -ForegroundColor Green "[INFO] Create dbs"

RestoreSqlDb -db_params $dbs

}
else{ write-host 'No DB found'}

$pathtojson = "C:\Services\PersonalInfoCenter\PushService\appsettings.json"

$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$json_appsetings.RabbitMqConnection.Host ="$shortRabbitStr; publisherConfirms=true; timeout=100; requestedHeartbeat=0"
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8
