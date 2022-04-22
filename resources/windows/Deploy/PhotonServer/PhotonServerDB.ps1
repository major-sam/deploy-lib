import-module '.\scripts\sideFunctions.psm1'

$serviceName = "PhotonServer"
$servicesFolder = "C:\Services"
$sitesFolder = "C:\inetpub"
$PhotonFolder = Join-Path -Path $servicesFolder -ChildPath $serviceName
$DeployPhotonFolder = Join-Path -Path $PhotonFolder -ChildPath "deploy"
$PhotonPluginFolder = Join-Path -Path $DeployPhotonFolder -ChildPath "$($serviceName)\bin"
Write-Host -ForegroundColor Green "[INFO] Create $($serviceName) database"
CreateSqlDatabase($serviceName)

Write-Host -ForegroundColor Green "[INFO] Invoke PhotonServerDbScript.sql"
Invoke-Sqlcmd `
    -Database $serviceName `
    -InputFile "$($PhotonPluginFolder)\Sql\PhotonServerDbScript.sql" `
    -ServerInstance $env:COMPUTERNAME `
    -QueryTimeout 720 `
    -ErrorAction continue