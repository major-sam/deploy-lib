Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "ActionLogService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\ActionLogService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
