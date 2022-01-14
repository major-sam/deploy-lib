# cleanup inetpub and IIS
Import-Module  -Force WebAdministration
Remove-Website -Name *
Remove-WebAppPool -name *
Stop-Service W3SVC
Get-ChildItem 'C:\inetpub'  -Exclude custerr, history, logs, temp, wwwroot  | %{ 
    "Removing file $($_.FullName)";Remove-Item -Force -Recurse -Path $_}
Start-Service W3SVC
