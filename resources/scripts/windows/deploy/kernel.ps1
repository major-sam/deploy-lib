import-module '.\scripts\sideFunctions.psm1'

$ProgressPreference = 'SilentlyContinue'
$targetDir = 'C:\Kernel'
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$pathtojson = "$targetDir\appsettings.json "
$transformLibPath = ".\scripts\Microsoft.Web.XmlTransform.dll"
$jsonDepth = 4
$queryTimeout = 720
$webConfig = "$targetDir\settings.xml"
$UnityConfig = "$targetDir\Config\UnityConfig.config"
$LogConfig = "$targetDir\Config\Log.Config"
$KernelConfig ="$targetDir\Kernel.exe.config"
$dbs = @(
	@{
		DbName = "BaltBetM"
		BackupFile = "\\server\tcbuild$\Testers\DB\BaltBetM.original.bak"
		RelocateFiles = @(
			@{
				SourceName = "BaltBetM"
				FileName = "BaltBetM.mdf"
			}
			@{
				SourceName = "CoefFileGroup"
				FileName = "CoefFileGroup.mdf"
			}
			@{
				SourceName = "BaltBet"
				FileName = "BaltBet.ldf"
			}
		)
	}
	@{
		DbName = "BaltBetMMirror"
		BackupFile = "\\server\tcbuild$\Testers\DB\BaltBetM.original.bak"
		RelocateFiles = @(
			@{
				SourceName = "BaltBetM"
				FileName = "BaltBetMMirror.mdf"
			}
			@{
				SourceName = "CoefFileGroup"
				FileName = "CoefFileGroupMirror.mdf"
			}
			@{
				SourceName = "BaltBet"
				FileName = "BaltBetMirror.ldf"
			}
		)
	}
	@{
		DbName = "BaltBetWeb"
		BackupFile = "\\server\tcbuild$\Testers\DB\BaltBetWeb.bak"
		RelocateFiles = @(
			@{
				SourceName = "BaltBetWeb"
				FileName = "BaltBetWeb.mdf"
			}
			@{
				SourceName = "Files"
				FileName = "Files"
			}
			@{
				SourceName = "BaltBetWeb_log"
				FileName = "BaltBetWeb.ldf"
			}
		)
	}
)
###### edit json files

Write-Host -ForegroundColor Green "[info] edit json files"
$json_appsetings = Get-Content -Raw -path $pathtojson | ConvertFrom-Json 
$HttpsInlineCertStore = '
    {     }
'| ConvertFrom-Json 
$json_appsetings.Kestrel.EndPoints.HttpsInlineCertStore =  $HttpsInlineCertStore
ConvertTo-Json $json_appsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"

### edit settings.xml
Write-Host -ForegroundColor Green "[INFO] Edit web.config of $webConfig"
$cachePath = 'c:\kCache'
if (!(test-path $cachePath)){
	md $cachePath

	}
$webdoc = [Xml](Get-Content $webConfig)
$webdoc.Settings.EventCacheSettings.Enabled = "false"
$webdoc.Settings.EventCacheSettings.CoefsCache.FileName = "$cachePath\EventCoefsCache.dat"
$webdoc.Settings.EventCacheSettings.CoefSumCache.FileName =  "$cachePath\EventCoefsSumCache.dat"

$webdoc.Settings.CurrentEventsJob.Enabled = "false"
$webdoc.Settings.CurrentEventsJob.FileCache.FileName = "$cachePath\EventCoefsCacheJob.dat"
$webdoc.Settings.AggregatorSettings.connection | % { $_.serviceType
    if ($_.serviceType -iin @("StandardPaymentService", "CpsPaymentService")){
		        $_.SetAttribute("notificationUrl","http://$($CurrentIpAddr):88/callback/baltbet" )
				    }
}
$webdoc.Save($webConfig)
### edit Log.config
Write-Host "[INFO] Edit web.config of $LogConfig"

$webdoc = [Xml](Get-Content $LogConfig)
$webdoc.log4net.appender|%{$_.file.value = $_.file.value.replace("Log\", "c:\logs\kernel\")}

$webdoc.Save($LogConfig)

### edit Unity.config.xml
Write-Host "[INFO] Edit web.config of $UnityConfig"

$webdoc = [Xml](Get-Content $UnityConfig)
($webdoc.unity.container|%{$_.register}|?{$_.type -like "Kernel.IStopKernelValidator, Kernel"}).constructor.param.value = "config\StartStop.txt"
$webdoc.Save($UnityConfig)

### edit kernel.exe.config
$conf = [Xml](Get-Content $KernelConfig)
$conf.configuration."system.serviceModel".services.service |% {$_.endpoint |% {$_.address = $_.address.replace("localhost",$CurrentIpAddr)}}
$conf.Save($KernelConfig)
###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create dbs"

RestoreSqlDb -db_params $dbs

# Выполняем скрипты из актуализации BaltBetM
$qwr="
	ALTER DATABASE BaltBetM
	COLLATE Cyrillic_General_CI_AS
	GO
	"
Invoke-Sqlcmd -Verbose -ServerInstance $env:COMPUTERNAME -Query $qwr -ErrorAction continue

$sqlFiles = Get-ChildItem -path "$($env:workspace)\scripts\deploy\KernelSql\*" -Include "*.sql" | Sort-Object -Property Name

$release_bak_folder = 
foreach ($file in $sqlFiles) {
	Write-Host -ForegroundColor Gray "[INFO] EXECUTED STARETED: " $file
	Invoke-Sqlcmd -verbose -QueryTimeout $queryTimeout -ServerInstance $env:COMPUTERNAME -Database $dbs[0].DbName -InputFile $file -ErrorAction continue
	Write-Host -ForegroundColor Green "[INFO] EXECUTED SUCCESSFULLY: " $file 
}
####KERNELWEB
$LogConfig  = "C:\KernelWeb\KernelWeb.exe.config"
Write-Host "[INFO] Edit web.config of $LogConfig"

$webdoc = [Xml](Get-Content $LogConfig)
$webdoc.configuration.log4net.appender|%{$_.file.value = "c:\logs\kernelWeb\"}

$webdoc.Save($LogConfig)
