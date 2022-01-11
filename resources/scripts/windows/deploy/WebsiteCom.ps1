import-module '.\scripts\sideFunctions.psm1'

#get release params

$targetDir  = 'C:\inetpub\WebsiteCom'
$ProgressPreference = 'SilentlyContinue'
$webConfig = "$targetDir\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$db = (@{
	DbName = "SiteCom"
	BackupFile = "\\server\tcbuild$\Testers\DB\SiteCom.bak"
	RelocateFiles = @(
			@{
				SourceName = "SiteCom"
				FileName = "SiteCom.mdf"
			}
			@{
				SourceName = "SiteCom_log"
				FileName = "SiteCom.ldf"
			}
		)
	})
RestoreSqlDb -db_params $db
###
#XML values replace
####
$webdoc = [Xml](Get-Content -Encoding UTF8 $webConfig)
$obj = $webdoc.configuration.appSettings.add | where {$_.key -like "ServerAddress" }
$obj.value = $CurrentIpAddr+":8082"
$obj = $webdoc.configuration.appSettings.add | where {$_.key -like "SiteServerAddress"} 
$obj.value = $CurrentIpAddr+":8088"
$obj = $webdoc.configuration.appSettings.add | where {$_.key -like "SiteServerAddressLogin"} 
$obj.value = $CurrentIpAddr+":8088"
$obj = $webdoc.configuration.appSettings.add | where {$_.key -like "IsSuperexpressEnabled"} 
$obj.value = "true"
$webdoc.configuration.'system.serviceModel'.client.endpoint | ForEach-Object { $_.address = ($_.address).replace("localhost","$($CurrentIpAddr)") }
$webdoc.Save($webConfig)
