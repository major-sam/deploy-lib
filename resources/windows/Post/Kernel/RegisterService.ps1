import-module '.\scripts\sideFunctions.psm1'

$serviceBin = Get-Item  "C:\Kernel\Kernel.exe"
$sname = RegisterWinService($serviceBin)
start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
$serviceBin = Get-Item  "C:\KernelWeb\KernelWeb.exe"
$sname = RegisterWinService($serviceBin)
write-host "$sname registred. Starting..."
(get-service $sname).start()
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
 return 0
