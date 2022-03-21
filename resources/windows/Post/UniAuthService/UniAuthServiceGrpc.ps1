# UniAuthServiceGrpc
Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "UniAuthServiceGrpc"
$serviceBin = Get-Item  "C:\Services\UniAuthService\${ServiceName}\Uni.AuthService.GrpcHost.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
