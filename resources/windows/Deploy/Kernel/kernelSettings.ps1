import-module '.\scripts\sideFunctions.psm1'

$ProgressPreference = 'SilentlyContinue'
$targetDir = 'C:\Kernel'
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$webConfig = "$targetDir\settings.xml"
$UnityConfig = "$targetDir\Config\UnityConfig.config"
$LogConfig = "$targetDir\Config\Log.Config"
$KernelConfig ="$targetDir\Kernel.exe.config"

$redispasswd = "$($ENV:REDIS_CREDS_PWD)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PWD)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
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

$xmlconfig.Settings.CpsSettings.FiscalizationSettings.rabbitMQConnectionString ="$shortRabbitStr;publisherConfirms=true;timeout=1000"
$xmlconfig.Settings.globalLog.rabbitmq.defaultConnectionString ="$shortRabbitStr;publisherConfirms=true;timeout=10000;requestedHeartbeat=0"

$webdoc.Settings.CurrentEventsJob.Enabled = "false"
$webdoc.Settings.CurrentEventsJob.FileCache.FileName = "$cachePath\EventCoefsCacheJob.dat"
$webdoc.Settings.AggregatorSettings.connection | % { $_.serviceType
	if ($_.serviceType -iin @("StandardPaymentService")) {
		$_.SetAttribute("AuthCertThumbprint", "$env:CLIENT_TEST_KERNEL_THUMBPRINT")
		$_.SetAttribute("GrpcAddress", "172.16.1.70:32421")
		$_.SetAttribute("WcfAddress", "https://payments.sandbox.baltbet.com/svc/PaymentService.svc")
		$_.SetAttribute("NotificationUrl", "http://$($CurrentIpAddr):88/callback/baltbet")
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
$conf.configuration."system.serviceModel".services.service | % { 
	$_.endpoint |% {$_.address = $_.address.replace("localhost",$CurrentIpAddr)}}
($xmlconfig.configuration.appSettings.add| ?{
	$_.key -ilike 'RabbitMQConnectionString'}).value =$shortRabbitStr
($xmlconfig.configuration.connectionStrings.add| ?{
	$_.name -ilike 'Redis'}
	).connectionString = "$shortRedisStr,connectTimeout=15000,syncTimeout=15000,asyncTimeout=15000"
$conf.Save($KernelConfig)

####KERNELWEB
$webLogConfig  = "C:\KernelWeb\KernelWeb.exe.config"
Write-Host "[INFO] Edit web.config of $webLogConfig"

$webdoc = [Xml](Get-Content $webLogConfig)
$webdoc.configuration.log4net.appender|%{$_.file.value = "c:\logs\kernelWeb\"}
($xmlconfig.configuration.connectionStrings.add| ?{$_.name -ilike 'RabbitMQ'}).connectionString =$shortRabbitStr

$webdoc.Save($webLogConfig)

