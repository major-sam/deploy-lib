Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "FavoritesService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\BaltBet.FavoritesService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
