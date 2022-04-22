import-module '.\scripts\sideFunctions.psm1'
. ".\PhotonServerVariables.ps1" 

$PhotonServerConfig = Join-Path -Path $DeployPhotonFolder -ChildPath "bin_Win64\PhotonServer.config"

## Edit Photon Server config
Write-Host -ForegroundColor Green "[INFO] Edit Photon Server config"
[xml]$configData = Get-Content -Encoding UTF8 -Path $PhotonServerConfig 
$configData.Configuration.PhotonServer.WebSocketListeners.WebSocketListener.CertificateName = "*.bb-webapps.com"

$configData.Save($PhotonServerConfig)