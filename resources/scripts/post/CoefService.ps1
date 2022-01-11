Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "CoefService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\CoefService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
