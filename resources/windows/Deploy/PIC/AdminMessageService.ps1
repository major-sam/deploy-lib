import-module '.\scripts\sideFunctions.psm1'
$config =  "C:\Services\PersonalInfoCenter\AdminMessageService\Log.config"
$svc = get-item $config
$webdoc = [Xml](Get-Content $svc.Fullname)
$webdoc.log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
$webdoc.Save($svc.Fullname)

$reportval =@"
[AdminMessageService]
$config
        .log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
$('='*60)


"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
