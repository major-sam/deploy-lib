Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "EraiService.WebUI"
$serviceBin = Get-Item  "C:\Services\ERAI\${ServiceName}\Erai.WebUI.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME