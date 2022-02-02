import-module '.\scripts\sideFunctions.psm1'

$serviceBin = Get-Item  "C:\Services\FavoritesService\BaltBet.FavoritesService.exe"
$sname = RegisterWinService($serviceBin)
start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
 return 0
