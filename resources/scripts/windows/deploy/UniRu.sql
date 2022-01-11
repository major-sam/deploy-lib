UPDATE [UniRu].Settings.SiteOptions SET Value = CASE Name
WHEN 'Global.CKFinderSettings.ImageHost' THEN 'https://#VM_HOSTNAME.bb-webapps.com:443'
WHEN 'Global.GlobalLog.BaltBetClientStatistics.StatisticsHandlerUrl' THEN 'https://#VM_HOSTNAME.bb-webapps.com:13443/st'
WHEN 'Global.GlobalLog.RabbitMq.DefaultConnectionString' THEN 'host=#VM_IP:5672; username=guest; password=guest; publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.GlobalLog.RabbitMq.GlobalLogger.ConnectionString' THEN 'host=#VM_IP:5672; username=guest; password=guest; publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.RecognitionCompletingPassportAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/completingPassportData/{0}'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.RecognitionResultsAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/completingPassportData/{0}'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.UploadingDocumentAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/Upload/{0}/{1}/{2}'
WHEN 'Global.MessagesServiceSettings.URL' THEN 'https://#VM_HOSTNAME.bb-webapps.com:4442/ '
WHEN 'Global.SignalR.Remote.Endpoint' THEN 'https://#VM_HOSTNAME.bb-webapps.com:8491/'
WHEN 'Registration.InSessionDataEncrptionPassphrase' THEN 'Qwerty1z'
WHEN 'SupportContacts.SupportEmail' THEN 'report@baltbet.ru'
WHEN 'UpdateApk.AndroidUrl' THEN 'https://apkupdater.baltbet.ru:1415/com.baltbet.clientapp'
WHEN 'UpdateApk.CheckUrl' THEN 'https://apkupdater-test.bb-webapps.com:1443/api/check/'
WHEN 'Global.WcfClient.WcfServicesHostAddress' THEN '#VM_IP'
WHEN 'OAuth.LastLogoutUrl' THEN 'https://#VM_HOSTNAME.bb-webapps.com:449/account/logout/last'
WHEN 'OAuth.TokenUrl' THEN 'https://#VM_HOSTNAME.bb-webapps.com:449/oauth/token'
WHEN 'Global.RabbitMq.NotificationGateWayBus.IsEnabled' THEN 'false'
ELSE Value END

IF EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'Payment.IsCupisPaymentsEnabled')
    UPDATE UniRu.Settings.SiteOptions SET Value = 'true'
	    WHERE Name = 'Payment.IsCupisPaymentsEnabled'
ELSE INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1, 'Payment.IsCupisPaymentsEnabled', 'true', 0)

IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'PlayerIdentificationSettings.ECupisAddressЕСИА')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,N'PlayerIdentificationSettings.ECupisAddressЕСИА','https://wallet.1cupis.ru/auth',0)


IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'Asterisk.IpAddress')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Asterisk.IpAddress','172.16.0.54',0)
IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'Asterisk.Port')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Asterisk.Port','5038',0)
IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'Asterisk.Login')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Asterisk.Login','site',0)
IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'Asterisk.Secret')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Asterisk.Secret','hzccIuSfo1rMgVBU',0)
