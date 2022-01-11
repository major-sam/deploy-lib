import-module '.\scripts\sideFunctions.psm1'

$svc = get-item	"C:\Services\PersonalInfoCenter\PushService\Log.config"
$webdoc = [Xml](Get-Content $svc.Fullname)
$webdoc.log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
$webdoc.Save($svc.Fullname)

CreateSqlDatabase ("PushService")
$file =	"C:\Services\PersonalInfoCenter\PushServiceDB\init.sql"
Invoke-Sqlcmd -ServerInstance $env:COMPUTERNAME -Database "PushService" -InputFile $file -Verbose
