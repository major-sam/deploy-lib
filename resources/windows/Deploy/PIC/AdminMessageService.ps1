import-module '.\scripts\sideFunctions.psm1'
$config =  "C:\Services\PersonalInfoCenter\AdminMessageService\Log.config"
$svc = get-item $config
$webdoc = [Xml](Get-Content $svc.Fullname)
$webdoc.log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
$webdoc.Save($svc.Fullname)


$pathtojson = "C:\Services\PersonalInfoCenter\AdminMessageService\appsettings.json"
$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$json_appsetings.CKFinder.Url = "https://$($env:COMPUTERNAME):44307/"
$json_appsetings.Authorization.Realm = "https://$($env:COMPUTERNAME).gkbaltbet.local:44307/"
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8

$reportval =@"
[AdminMessageService]
$config
        .log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
$('='*60)


"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
