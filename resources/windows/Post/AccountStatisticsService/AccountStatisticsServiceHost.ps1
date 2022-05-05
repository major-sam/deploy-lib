Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$serviceBinPath = "C:\Services\AccountStatisticsService\BaltBet.AccountStatisticsService.Host\BaltBet.AccountStatisticsService.Host.exe"
if (test-path $serviceBinPath){
    $serviceBin = Get-Item $serviceBinPath
    $sname = RegisterWinService($serviceBin)
    Start-Service $sname
    Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
}
else{
    write-host "file $serviceBinPath not exists"
}
