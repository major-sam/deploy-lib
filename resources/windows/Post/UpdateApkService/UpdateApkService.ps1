<# Добавить в настройки Юни
Id	GroupId	Name	Value	IsInherited
302	1	UpdateApk.CheckUrl	https://#VM_HOSTNAME.bb-webapps.com:4458/api/check/	0
353	1	UpdateApk.CacheExpiry	0.0:0:40.0	0
#>

$db = "UniRu"
$q = "
IF EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'UpdateApk.CheckUrl')
    UPDATE UniRu.Settings.SiteOptions SET Value = 'https://#VM_HOSTNAME.bb-webapps.com:4458/api/check/'
	    WHERE Name = 'UpdateApk.CheckUrl'
ELSE INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1, 'UpdateApk.CheckUrl', 'https://#VM_HOSTNAME.bb-webapps.com:4458/api/check/', 0)

IF EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'UpdateApk.CacheExpiry')
    UPDATE UniRu.Settings.SiteOptions SET Value = '0.0:0:40.0'
	    WHERE Name = 'UpdateApk.CacheExpiry'
ELSE INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
	VALUES (1, 'UpdateApk.CacheExpiry', '0.0:0:40.0', 0)
"


$query = $q.replace("#VM_HOSTNAME", $env:COMPUTERNAME)

Invoke-Sqlcmd -QueryTimeout 720 -verbose -ServerInstance $env:COMPUTERNAME -Database $db -query $query -ErrorAction Stop
