Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$serviceBin = Get-Item  "C:\Services\IdentificationDocumentService\IdentificationDocumentService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME