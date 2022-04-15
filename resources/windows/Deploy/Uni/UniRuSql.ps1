Import-module '.\scripts\sideFunctions.psm1'

$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$q = "
UPDATE [UniRu].Settings.SiteOptions SET Value = CASE Name
WHEN 'Global.CKFinderSettings.ImageHost' THEN 'https://#VM_HOSTNAME.bb-webapps.com:443'
WHEN 'Global.GlobalLog.BaltBetClientStatistics.StatisticsHandlerUrl' THEN 'https://#VM_HOSTNAME.bb-webapps.com:13443/st'
WHEN 'Global.GlobalLog.RabbitMq.DefaultConnectionString' THEN 'host=#VM_IP:5672; username=test; password=test; publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'Global.GlobalLog.RabbitMq.GlobalLogger.ConnectionString' THEN 'host=#VM_IP:5672; username=test; password=test; publisherConfirms=true; timeout=100; requestedHeartbeat=0'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.RecognitionCompletingPassportAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/completingPassportData/{0}'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.RecognitionResultsAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/passports/{0}'
WHEN 'PlayerIdentificationSettings.DocumentUploadSettings.UploadingDocumentAddress' THEN 'http://localhost:8123/api/AccountFiles/Cps/Upload/{0}/{1}/{2}/{3}'
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

	
IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = N'PlayerIdentificationSettings.ECupisAddressЕСИА')
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
	VALUES (1,'Asterisk.Secret','$($env:AsteriskSeceret)',0)


IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'Pages.Prematch.IsHotEventsEnabled')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Pages.Prematch.IsHotEventsEnabled','true',0)
IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'Pages.Events.IsMarketsClientSideRenderingEnabled')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Pages.Events.IsMarketsClientSideRenderingEnabled','true',0)


IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'Global.RemoteWebApi.PrematchService.Uri')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'Global.RemoteWebApi.PrematchService.Uri','https://#VM_HOSTNAME.bb-webapps.com:4435',0)
	
	
IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'PlayerIdentificationSettings.WrongAttemptCount')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'PlayerIdentificationSettings.WrongAttemptCount','5',0)

DELETE FROM UniRu.Settings.SiteOptions WHERE NAME like '%RemoteWebApi%'


IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'BroadcastSettings.SetkaCup.StreamUrl')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'BroadcastSettings.SetkaCup.StreamUrl','https://#VM_HOSTNAME.bb-webapps.com:4443/broadcast/setkacup/{matchId}',0)

IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'BroadcastSettings.MatchTv.StreamUrl')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'BroadcastSettings.MatchTv.StreamUrl','https://#VM_HOSTNAME.bb-webapps.com:4443/dm-mobileapp/broadcast/matchtv/{matchId}',0)

IF NOT EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'BroadcastSettings.Rfpl.StreamUrl')
	INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1,'BroadcastSettings.Rfpl.StreamUrl','https://#VM_HOSTNAME.bb-webapps.com:4443/dm-mobileapp/broadcast/umamedia/{matchId}',0)


Use UniRu
SET IDENTITY_INSERT [Settings].[SiteOptions] ON 

INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1354, 1, N'Payment.Invoice.IsOnlineBanksEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1355, 1, N'Payment.Invoice.Channels[0].Channel', N'Card', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1356, 1, N'Payment.Invoice.Channels[0].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1357, 1, N'Payment.Invoice.Channels[0].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1358, 1, N'Payment.Invoice.Channels[0].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1359, 1, N'Payment.Invoice.Channels[0].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1360, 1, N'Payment.Invoice.Channels[1].Channel', N'QiwiWallet', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1361, 1, N'Payment.Invoice.Channels[1].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1362, 1, N'Payment.Invoice.Channels[1].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1363, 1, N'Payment.Invoice.Channels[1].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1364, 1, N'Payment.Invoice.Channels[1].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1365, 1, N'Payment.Invoice.Channels[2].Channel', N'YandexMoney', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1366, 1, N'Payment.Invoice.Channels[2].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1367, 1, N'Payment.Invoice.Channels[2].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1368, 1, N'Payment.Invoice.Channels[2].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1369, 1, N'Payment.Invoice.Channels[2].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1370, 1, N'Payment.Invoice.Channels[3].Channel', N'WM', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1371, 1, N'Payment.Invoice.Channels[3].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1372, 1, N'Payment.Invoice.Channels[3].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1373, 1, N'Payment.Invoice.Channels[3].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1374, 1, N'Payment.Invoice.Channels[3].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1375, 1, N'Payment.Invoice.Channels[4].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1376, 1, N'Payment.Invoice.Channels[4].Channel', N'ApplePay', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1377, 1, N'Payment.Invoice.Channels[5].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1378, 1, N'Payment.Invoice.Channels[5].Channel', N'AlfaClick', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1379, 1, N'Payment.Invoice.Channels[6].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1380, 1, N'Payment.Invoice.Channels[6].Channel', N'CupisWallet', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1381, 1, N'Payment.Invoice.Channels[7].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1382, 1, N'Payment.Invoice.Channels[7].Channel', N'GooglePay', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1383, 1, N'Payment.Invoice.Channels[8].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1384, 1, N'Payment.Invoice.Channels[8].Channel', N'SamsungPay', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1385, 1, N'Payment.Invoice.Channels[9].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1386, 1, N'Payment.Invoice.Channels[9].Channel', N'SberPay', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1387, 1, N'Payment.Invoice.Channels[10].Channel', N'Mts', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1388, 1, N'Payment.Invoice.Channels[10].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1389, 1, N'Payment.Invoice.Channels[10].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1390, 1, N'Payment.Invoice.Channels[10].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1391, 1, N'Payment.Invoice.Channels[10].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1392, 1, N'Payment.Invoice.Channels[11].Channel', N'Beeline', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1393, 1, N'Payment.Invoice.Channels[11].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1394, 1, N'Payment.Invoice.Channels[11].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1395, 1, N'Payment.Invoice.Channels[11].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1396, 1, N'Payment.Invoice.Channels[11].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1397, 1, N'Payment.Invoice.Channels[12].Channel', N'Megafon', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1398, 1, N'Payment.Invoice.Channels[12].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1399, 1, N'Payment.Invoice.Channels[12].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1400, 1, N'Payment.Invoice.Channels[12].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1401, 1, N'Payment.Invoice.Channels[12].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1402, 1, N'Payment.Invoice.Channels[13].Channel', N'Tele2', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1403, 1, N'Payment.Invoice.Channels[13].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1404, 1, N'Payment.Invoice.Channels[13].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1405, 1, N'Payment.Invoice.Channels[13].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1406, 1, N'Payment.Invoice.Channels[13].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1407, 1, N'Payment.Payout.Channels[0].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1408, 1, N'Payment.Payout.Channels[0].Channel', N'BankAccount', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1409, 1, N'Payment.Payout.Channels[1].Channel', N'Card', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1410, 1, N'Payment.Payout.Channels[1].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1411, 1, N'Payment.Payout.Channels[1].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1412, 1, N'Payment.Payout.Channels[1].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1413, 1, N'Payment.Payout.Channels[1].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1414, 1, N'Payment.Payout.Channels[2].Channel', N'QiwiWallet', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1415, 1, N'Payment.Payout.Channels[2].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1416, 1, N'Payment.Payout.Channels[2].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1417, 1, N'Payment.Payout.Channels[2].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1418, 1, N'Payment.Payout.Channels[2].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1419, 1, N'Payment.Payout.Channels[3].Channel', N'YandexMoney', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1420, 1, N'Payment.Payout.Channels[3].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1421, 1, N'Payment.Payout.Channels[3].ChannelGroup', N'None', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1422, 1, N'Payment.Payout.Channels[3].MinAmount', N'100', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1423, 1, N'Payment.Payout.Channels[3].MaxAmount', N'1000', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1424, 1, N'Payment.Payout.Channels[4].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1425, 1, N'Payment.Payout.Channels[4].Channel', N'CupisWallet', 0)

INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1426, 1, N'Pages.History.IsBetSellEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1427, 1, N'Pages.History.IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1428, 1, N'Widgets.Interesting.IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1429, 1, N'Pages.Home.Sports[0].Title', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1430, 1, N'Pages.Home.Sports[0].Description', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1431, 1, N'Pages.Home.Sports[0].Keywords', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1432, 1, N'Pages.Home.Sports[0].PromoText1', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1433, 1, N'Pages.Home.Sports[0].PromoText2', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1434, 1, N'Pages.Home.Sports[1].SportTitle', N'Теннис', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1435, 1, N'Pages.Home.Sports[1].SportTypeId', N'Tennis', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1436, 1, N'Pages.Home.Sports[1].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1437, 1, N'Pages.Home.Sports[1].SportString', N'tennis', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1438, 1, N'Pages.Home.Sports[1].Title', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1439, 1, N'Pages.Home.Sports[1].Description', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1440, 1, N'Pages.Home.Sports[1].Keywords', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1441, 1, N'Pages.Home.Sports[1].PromoText1', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1442, 1, N'Pages.Home.Sports[1].PromoText2', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1443, 1, N'Widgets.Interesting.Sports[1].SportTitle', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1444, 1, N'Widgets.Interesting.Sports[1].SportTypeId', N'Tennis', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1445, 1, N'Widgets.Interesting.Sports[1].IsEnabled', N'true', 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1446, 1, N'Widgets.Interesting.Sports[1].MinBestBet', NULL, 0)
INSERT [Settings].[SiteOptions] ([Id], [GroupId], [Name], [Value], [IsInherited]) VALUES (1447, 1, N'Widgets.Interesting.Sports[1].MinBestExpress', NULL, 0)
update [Settings].[SiteOptions] set Value='true' where name ='Widgets.Interesting.Sports[0].IsEnabled'
SET IDENTITY_INSERT [Settings].[SiteOptions] OFF

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'PreRegistrationData')
BEGIN
	DROP TABLE IF EXISTS dbo.PreRegistrationData;
	PRINT '[INFO] DROP dbo.PreRegistrationData';
END
ELSE
BEGIN
	PRINT '[INFO] Table dbo.PreRegistrationData does not exist, nothing to DROP...OK';
END
"

$release_bak_folder = "\\server\tcbuild$\Testers\DB"
$queryTimeout = 720

$dbs = @(
	@{
		DbName = "UniRu"
		BackupFile = "$release_bak_folder\UniRu.bak" 
        RelocateFiles = @(
			@{
				SourceName = "UniCps"
				FileName = "UniRu.mdf"
			}
			@{
				SourceName = "UniCps_log"
				FileName = "UniRu.ldf"
			}
		)    
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create dbs"

RestoreSqlDb -db_params $dbs

$query = $q.replace( "#VM_IP",  $IPAddress).replace( "#VM_HOSTNAME", $env:COMPUTERNAME)

Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $dbs[0].DbName -query $query -ErrorAction Stop
Set-Location C:\
