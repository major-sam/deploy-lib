Import-module '.\scripts\sideFunctions.psm1'


$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$Dbname =  "UniAdministration"
$query = "
UPDATE [$dbname].Settings.SiteOptions SET Value = CASE Name
WHEN 'Global.CKFinderSettings.ImageHost' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:443'
WHEN 'Global.GlobalLog.BaltBetClientStatistics.StatisticsHandlerUrl' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:13443/st'
WHEN 'Global.GlobalLog.RabbitMq.DefaultConnectionString' THEN 'host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT); username=$($ENV:RABBIT_CREDS_USR); password=$($ENV:RABBIT_CREDS_PSW)$($ENV:VM_ID); publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.GlobalLog.RabbitMq.GlobalLogger.ConnectionString' THEN 'host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT); username=$($ENV:RABBIT_CREDS_USR); password=$($ENV:RABBIT_CREDS_PSW)$($ENV:VM_ID); publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.RabbitMq.AccountBus.ConnectionString' THEN 'host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT); username=$($ENV:RABBIT_CREDS_USR); password=$($ENV:RABBIT_CREDS_PSW)$($ENV:VM_ID); publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.KernelRedisConnectionString' THEN '$($ENV:REDIS_HOST):$($ENV:REDIS_PORT),syncTimeout=10000,allowAdmin=True,connectTimeout=10000,ssl=False,abortConnect=False,connectRetry=10,proxy=None'
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
WHEN 'OAuth.TokenUrl' THEN 'https://$($env:computername.ToLower()).bb-webapps.com:449/oauth/token'
WHEN 'Global.RabbitMq.NotificationGateWayBus.IsEnabled' THEN 'false'
ELSE Value END

IF EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Payment.IsCupisPaymentsEnabled')
    UPDATE $dbname.Settings.SiteOptions SET Value = 'true'
	    WHERE Name = 'Payment.IsCupisPaymentsEnabled'
ELSE INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1, 'Payment.IsCupisPaymentsEnabled', 'true', 0)

	
IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = N'PlayerIdentificationSettings.ECupisAddressЕСИА')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,N'PlayerIdentificationSettings.ECupisAddressЕСИА','https://wallet.1cupis.ru/auth',0)


IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Asterisk.IpAddress')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Asterisk.IpAddress','172.16.0.54',0)
IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Asterisk.Port')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Asterisk.Port','5038',0)
IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Asterisk.Login')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Asterisk.Login','site',0)
IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Asterisk.Secret')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Asterisk.Secret','$($env:AsteriskSecret)',0)


IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Pages.Prematch.IsHotEventsEnabled')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Pages.Prematch.IsHotEventsEnabled','true',0)
IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Pages.Events.IsMarketsClientSideRenderingEnabled')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Pages.Events.IsMarketsClientSideRenderingEnabled','true',0)


IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Global.RemoteWebApi.PrematchService.Uri')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Global.RemoteWebApi.PrematchService.Uri','https://$($env:computername.ToLower()).bb-webapps.com:4435',0)
	
	
IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'PlayerIdentificationSettings.WrongAttemptCount')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'PlayerIdentificationSettings.WrongAttemptCount','5',0)

DELETE FROM $dbname.Settings.SiteOptions WHERE NAME like '%RemoteWebApi%'


IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'BroadcastSettings.SetkaCup.StreamUrl')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'BroadcastSettings.SetkaCup.StreamUrl','https://$($env:computername.ToLower()).bb-webapps.com:4443/broadcast/setkacup/{matchId}',0)

IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'BroadcastSettings.MatchTv.StreamUrl')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'BroadcastSettings.MatchTv.StreamUrl','https://$($env:computername.ToLower()).bb-webapps.com:4443/dm-mobileapp/broadcast/matchtv/{matchId}',0)

IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'BroadcastSettings.Rfpl.StreamUrl')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'BroadcastSettings.Rfpl.StreamUrl','https://$($env:computername.ToLower()).bb-webapps.com:4443/dm-mobileapp/broadcast/umamedia/{matchId}',0)

IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Global.RabbitMq.PicBus.ConnectionString')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Global.RabbitMq.PicBus.ConnectionString','host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT); username=$($ENV:RABBIT_CREDS_USR); password=$($ENV:RABBIT_CREDS_PSW)$($ENV:VM_ID); publisherConfirms=true; timeout=100; requestedHeartbeat=0',0)
IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Global.RabbitMq.PicBus.IsEnabled')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Global.RabbitMq.PicBus.IsEnabled','true',0)
IF NOT EXISTS (SELECT * FROM $dbname.Settings.SiteOptions	WHERE Name = 'Global.RabbitMq.PicBus.Exchange')
	INSERT INTO $dbname.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Global.RabbitMq.PicBus.Exchange','Exchange.Pic.Ru',0)	
"
###vars
$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "C:\inetpub\ClientWorkPlace\DB"

$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = Join-Path $release_bak_folder "init_admin.bak" 
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create and restore db $Dbname"
RestoreSqlDb -db_params $dbs
Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $DbName -query $query -ErrorAction Stop
