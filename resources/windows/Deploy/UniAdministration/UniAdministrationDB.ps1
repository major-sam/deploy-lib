Import-module '.\scripts\sideFunctions.psm1'


$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$Dbname =  "UniAdministration"
$query = "
UPDATE [$dbname].Settings.SiteOptions SET Value = CASE Name
WHEN 'Global.CKFinderSettings.ImageHost' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:443'
WHEN 'Global.GlobalLog.BaltBetClientStatistics.StatisticsHandlerUrl' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:13443/st'
WHEN 'Global.GlobalLog.RabbitMq.DefaultConnectionString' THEN 'host=$($ENV:RABBIT_HOST); username=$($ENV:RABBIT_CREDS_USR); password=$($ENV:RABBIT_CREDS_PSW); publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.GlobalLog.RabbitMq.GlobalLogger.ConnectionString' THEN 'host=$($ENV:RABBIT_HOST); username=$($ENV:RABBIT_CREDS_USR); password=$($ENV:RABBIT_CREDS_PSW); publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.RabbitMq.AccountBus.ConnectionString' THEN 'host=$($ENV:RABBIT_HOST); username=$($ENV:RABBIT_CREDS_USR); password=$($ENV:RABBIT_CREDS_PSW); publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.KernelRedisConnectionString' THEN '$($ENV:REDIS_HOST),password=$($ENV:REDIS_CREDS_PSW),syncTimeout=10000,allowAdmin=True,connectTimeout=10000,ssl=False,abortConnect=False,connectRetry=10,proxy=None'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.RecognitionCompletingPassportAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/completingPassportData/{0}'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.RecognitionResultsAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/passports/{0}'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.UploadingDocumentAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/Upload/{0}/{1}/{2}/{3}'
WHEN 'Global.MessagesServiceSettings.URL' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:4442/ '
WHEN 'Global.SignalR.Remote.Endpoint' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:8491/'
WHEN 'Registration.InSessionDataEncrptionPassphrase' THEN 'Qwerty1z'
WHEN 'SupportContacts.SupportEmail' THEN 'report@baltbet.ru'
WHEN 'UpdateApk.AndroidUrl' THEN 'https://apkupdater.baltbet.ru:1415/com.baltbet.clientapp'
WHEN 'UpdateApk.CheckUrl' THEN 'https://apkupdater-test.bb-webapps.com:1443/api/check/'
WHEN 'Global.WcfClient.WcfServicesHostAddress' THEN '$($IPAddress)'
WHEN 'OAuth.LastLogoutUrl' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:449/account/logout/last'
WHEN 'OAuth.TokenUrl' THEN '/oauth/token'
WHEN 'Global.RabbitMq.NotificationGateWayBus.IsEnabled' THEN 'false'
WHEN 'Payment.IsCupisPaymentsEnabled' THEN 'true'
WHEN N'PlayerIdentificationSettings.ECupisAddressЕСИА' THEN 'https://wallet.1cupis.ru/auth'
WHEN 'Asterisk.IpAddress' THEN '172.16.0.54'
WHEN 'Asterisk.Port' THEN '5038'
WHEN 'Asterisk.Login' THEN 'site'
WHEN 'Asterisk.Secret' THEN '$($env:AsteriskSecret)'
WHEN 'Pages.Prematch.IsHotEventsEnabled' THEN 'true'
WHEN 'Pages.Events.IsMarketsClientSideRenderingEnabled' THEN 'true'
WHEN 'Global.RemoteWebApi.PrematchService.Uri' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:4435'
WHEN 'PlayerIdentificationSettings.WrongAttemptCount' THEN '5'
WHEN 'BroadcastSettings.SetkaCup.StreamUrl' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:4443/broadcast/setkacup/{matchId}'
WHEN 'BroadcastSettings.MatchTv.StreamUrl' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:4443/dm-mobileapp/broadcast/matchtv/{matchId}'
WHEN 'BroadcastSettings.Rfpl.StreamUrl' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:4443/dm-mobileapp/broadcast/umamedia/{matchId}'
WHEN 'Global.RabbitMq.PicBus.ConnectionString' THEN 'host=$($ENV:RABBIT_HOST); username=$($ENV:RABBIT_CREDS_USR); password=$($ENV:RABBIT_CREDS_PSW); publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.RabbitMq.PicBus.IsEnabled' THEN 'true'
WHEN 'Global.RabbitMq.PicBus.Exchange' THEN 'Exchange.Pic.Ru'
WHEN 'Pages.History.IsBetCalculationEnabled' THEN 'false'
ELSE Value END

UPDATE [$dbname].Settings.SiteOptionsGroups SET Host = CASE Instance
WHEN 'UniRu' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:4443'
WHEN 'UniComUz' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:5443'
WHEN 'UniComKyz' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:5445'
ELSE Host END
"
###vars
$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "C:\Services\UniAdministrationDB"

$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = Join-Path $release_bak_folder "init_Admin.bak" 
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create and restore db $Dbname"
RestoreSqlDb -db_params $dbs
Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $DbName -query $query -ErrorAction Stop
