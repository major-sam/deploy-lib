Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "EmployeeService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\EmployeeService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME