# меняем в админке урл до старого веб апи

$query = "
UPDATE UniRu.Settings.SiteOptions
SET Value = '/oauth/token'
WHERE Name = 'OAuth.TokenUrl'

IF EXISTS (SELECT * FROM UniRu.Settings.SiteOptions	WHERE Name = 'OAuth.LastLogoutUrl')
    DELETE Settings.SiteOptions WHERE Name = 'OAuth.LastLogoutUrl'
GO
"

Invoke-Sqlcmd -Database UniRu -Query $query