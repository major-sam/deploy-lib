import-module '.\scripts\sideFunctions.psm1'

$svc = get-item "C:\Services\PersonalInfoCenter\AdminMessageService\Log.config"
$webdoc = [Xml](Get-Content $svc.Fullname)
$webdoc.log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
$webdoc.Save($svc.Fullname)
