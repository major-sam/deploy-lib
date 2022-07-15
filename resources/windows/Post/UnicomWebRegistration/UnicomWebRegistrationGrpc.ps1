# UniAuthServiceGrpc
Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "UnicomWebRegistrationGrpc"
$serviceBin = Get-Item  "C:\Services\UnicomWebRegistration\${ServiceName}\Web.Registration.GrpcHost.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
