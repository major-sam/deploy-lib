import-module '.\scripts\sideFunctions.psm1'
$config =  "C:\Services\PersonalInfoCenter\AdminMessageService\Log.config"
$svc = get-item $config
$webdoc = [Xml](Get-Content $svc.Fullname)
$webdoc.log4net.appender.file.value = "c:\logs\PersonalInfoCenter\$($svc.Directory.name)-"
$webdoc.Save($svc.Fullname)


$pathtojson = "C:\Services\PersonalInfoCenter\AdminMessageService\appsettings.json"
$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$json_appsetings.CKFinder.Url = "https://$($env:COMPUTERNAME).bb-webapps.com:44307/".ToLower()
$json_appsetings.Authorization.Realm = "https://$($env:COMPUTERNAME).bb-webapps.com:44307/".ToLower()
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8
