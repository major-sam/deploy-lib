# PAY-757
# https://jira.baltbet.ru:8443/browse/PAY-757
# Перевод сервиса PSH на GRPC ASAP

Import-module '.\scripts\sideFunctions.psm1'


$ServiceName = "PaymentSystemHandlers"

# Регистрируем сервис
$serviceBinPath = "C:\Services\$ServiceName\PaymentSystemHandlers.exe"
if (test-path $serviceBinPath) {
    $serviceBin = Get-Item $serviceBinPath
    $sname = RegisterWinService($serviceBin)
    Start-Service $sname
    Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
}
else {
    write-host "[WARN] File $serviceBinPath does not exist"
}
