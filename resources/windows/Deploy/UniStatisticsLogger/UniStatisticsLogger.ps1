# Сервис статистики
$WebConfig =  "C:\services\UniStatisticsLogger\Web.config"

$redispasswd = $ENV:REDIS_CREDS_PSW
$shortRedisStr="$($env:REDIS_HOST),password=$redispasswd"
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"


Write-Host "[INFO] Edit Web.config of $WebConfig"
$webdoc = [Xml](Get-Content $WebConfig -Encoding utf8)
$webdoc.configuration.globalLog.rabbitmq.defaultConnectionString = "$shortRabbitStr;publisherConfirms=true; timeout=1000; requestedHeartbeat=0"
$webdoc.configuration.log4net.appender | % { $_.file.value = $_.file.value.replace("logs", "c:/logs/UniStatisticsLogger")}
$webdoc.Save($WebConfig)
