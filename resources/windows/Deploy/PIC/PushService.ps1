import-module '.\scripts\sideFunctions.psm1'
$config = 	"C:\Services\PersonalInfoCenter\PushService\Log.config"
$svc = get-item $config 
$webdoc = [Xml](Get-Content $svc.Fullname)
$webdoc.log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
$webdoc.Save($svc.Fullname)

CreateSqlDatabase ("PushService")
$file =	"C:\Services\PersonalInfoCenter\PushServiceDB\init.sql"
Invoke-Sqlcmd -ServerInstance $env:COMPUTERNAME -Database "PushService" -InputFile $file -Verbose

$reportval =@"
[PushServiceDB]
$config
        .log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"

"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
