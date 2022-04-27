$serviceName = "PhotonServer"
$servicesFolder = "C:\Services"
$sitesFolder = "C:\inetpub"
$PhotonFolder = Join-Path -Path $servicesFolder -ChildPath $serviceName
$DeployPhotonFolder = Join-Path -Path $PhotonFolder -ChildPath "deploy"
$PhotonPluginFolder = Join-Path -Path $DeployPhotonFolder -ChildPath "$($serviceName)\bin"