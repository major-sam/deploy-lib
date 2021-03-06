<# Добавить в настройки Юни
Id	GroupId	Name	Value	IsInherited
302	1	UpdateApk.CheckUrl	https://$($ENV:COMPUTERNAME).bb-webapps.com:4458/api/check/	0
353	1	UpdateApk.CacheExpiry	0.0:0:40.0	0
#>

$db = "UniAdministration"
$query = "
IF EXISTS (SELECT * FROM UniAdministration.Settings.SiteOptions	WHERE Name = 'UpdateApk.CheckUrl')
    UPDATE UniAdministration.Settings.SiteOptions SET Value = 'https://$($ENV:COMPUTERNAME).bb-webapps.com:4458/api/check/'
	    WHERE Name = 'UpdateApk.CheckUrl'
ELSE INSERT INTO UniAdministration.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1, 'UpdateApk.CheckUrl', 'https://$($ENV:COMPUTERNAME).bb-webapps.com:4458/api/check/', 0)

IF EXISTS (SELECT * FROM UniAdministration.Settings.SiteOptions	WHERE Name = 'UpdateApk.CacheExpiry')
    UPDATE UniAdministration.Settings.SiteOptions SET Value = '0.0:0:40.0'
	    WHERE Name = 'UpdateApk.CacheExpiry'
ELSE INSERT INTO UniAdministration.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1, 'UpdateApk.CacheExpiry', '0.0:0:40.0', 0)
"



Invoke-Sqlcmd -QueryTimeout 720 -verbose -ServerInstance $env:COMPUTERNAME -Database $db -query $query -ErrorAction Stop
