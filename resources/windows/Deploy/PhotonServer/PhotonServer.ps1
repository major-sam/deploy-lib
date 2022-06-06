import-module '.\scripts\sideFunctions.psm1'

$serviceName = "PhotonServer"
$servicesFolder = "C:\Services"
$sitesFolder = "C:\inetpub"
$PhotonFolder = Join-Path -Path $servicesFolder -ChildPath $serviceName
$DeployPhotonFolder = Join-Path -Path $PhotonFolder -ChildPath "deploy"
$PhotonPluginFolder = Join-Path -Path $DeployPhotonFolder -ChildPath "$($serviceName)\bin"
$PhotonServerConfig = Join-Path -Path $DeployPhotonFolder -ChildPath "bin_Win64\PhotonServer.config"

## Edit Photon Server config
Write-Host -ForegroundColor Green "[INFO] Edit Photon Server config"
[xml]$configData = Get-Content -Encoding UTF8 -Path $PhotonServerConfig 
$configData.Configuration.PhotonServer.WebSocketListeners.WebSocketListener.CertificateName = "*.bb-webapps.com"
$configData.Configuration.ConnectionStrings | % {
    if ( $_.name -eq "DrumLogic.DrumMachine.Data.SlotDataContext" ) {$_.connectionString = "server=$($env:COMPUTERNAME);Integrated Security=true;MultipleActiveResultSets=true;Initial Catalog=Photon_Gambling;"}
}

$configData.Save($PhotonServerConfig)