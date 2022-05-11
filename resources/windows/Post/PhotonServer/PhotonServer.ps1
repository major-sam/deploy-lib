import-module '.\scripts\sideFunctions.psm1'

$serviceName = "PhotonServer"
$servicesFolder = "C:\Services"
$sitesFolder = "C:\inetpub"
$PhotonFolder = Join-Path -Path $servicesFolder -ChildPath $serviceName
$DeployPhotonFolder = Join-Path -Path $PhotonFolder -ChildPath "deploy"
$PhotonPluginFolder = Join-Path -Path $DeployPhotonFolder -ChildPath "$($serviceName)\bin"
$PhotonServerConfig = Join-Path -Path $DeployPhotonFolder -ChildPath "bin_Win64\PhotonServer.config"
$PhotonPluginConfig = Join-Path -Path $PhotonPluginFolder -ChildPath "PhotonServer.dll.config"

## Edit Photon plugin config
Write-Host -ForegroundColor Green "[INFO] Edit Photon plugin config"
[xml]$configData = Get-Content -Encoding UTF8 -Path $PhotonPluginConfig
$kernelWebConfig = "C:\KernelWeb\KernelWeb.exe.config"
$kernelUserName = (([xml](Get-Content -Encoding UTF8 -Path $kernelWebConfig)).configuration.appSettings.add | ? key -eq "ParserLogin").value
$kernelPassword = (([xml](Get-Content -Encoding UTF8 -Path $kernelWebConfig)).configuration.appSettings.add | ? key -eq "ParserPassword").value
$baseUri = "http://localhost:" + ([xml](Get-Content -Encoding UTF8 -Path "C:\KernelWeb\Settings.xml")).Settings.Ports.Port[0]

$configData.configuration.kernelService.kernelUserName = $kernelUserName
$configData.configuration.kernelService.kernelPassword = $kernelPassword
$configData.configuration.kernelService.baseUri = $baseUri

$configData.Save($PhotonPluginConfig)


## Add photon.json to WebsiteCom directory
Write-Host -ForegroundColor Green "[INFO] Add photon.json to WebsiteCom directory"

$photonPort = ([xml](Get-Content -Encoding UTF8 -Path $PhotonServerConfig)).Configuration.PhotonServer.WebSocketListeners.WebSocketListener.Port
$data = '{ "url": "wss://' + "$($env:COMPUTERNAME):$($photonPort)" + '" }'
Set-Content -Encoding UTF8 -Path "$($sitesFolder)\WebsiteCom\photon.json" -Value $data

