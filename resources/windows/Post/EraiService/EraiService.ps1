Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "EraiService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\EraiService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME