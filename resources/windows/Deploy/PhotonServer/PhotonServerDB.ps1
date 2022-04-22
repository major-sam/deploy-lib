import-module '.\scripts\sideFunctions.psm1'


Write-Host -ForegroundColor Green "[INFO] Create $($serviceName) database"
CreateSqlDatabase($serviceName)

Write-Host -ForegroundColor Green "[INFO] Invoke PhotonServerDbScript.sql"
Invoke-Sqlcmd `
    -Database $serviceName `
    -InputFile "$($PhotonPluginFolder)\Sql\PhotonServerDbScript.sql" `
    -ServerInstance $env:COMPUTERNAME `
    -QueryTimeout 720 `
    -ErrorAction continue