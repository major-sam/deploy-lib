# cleanup inetpub and IIS
Import-Module  -Force WebAdministration
Remove-Website -Name *
Remove-WebAppPool -name *
Stop-Service W3SVC
Get-ChildItem 'C:\inetpub'  -Exclude custerr, history, temp, wwwroot  | %{ 
    "Removing files in $($_.FullName)"
    if ($_.Name -eq "logs") {
        Remove-Item -Force -Recurse -Path "$($_)\*" 
        return
    }
    Remove-Item -Force -Recurse -Path $_.FullName
}
Start-Service W3SVC
