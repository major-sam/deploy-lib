import-module '.\scripts\sideFunctions.psm1'

$ProgressPreference = 'SilentlyContinue'
$targetDir = 'C:\Kernel'
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$webConfig = "$targetDir\settings.xml"
$UnityConfig = "$targetDir\Config\UnityConfig.config"
$LogConfig = "$targetDir\Config\Log.Config"
$KernelConfig ="$targetDir\Kernel.exe.config"

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

####KERNELWEB
$LogConfig  = "C:\KernelWeb\KernelWeb.exe.config"
Write-Host "[INFO] Edit web.config of $LogConfig"

$webdoc = [Xml](Get-Content $LogConfig)
$webdoc.configuration.log4net.appender|%{$_.file.value = "c:\logs\kernelWeb\"}

$webdoc.Save($LogConfig)
