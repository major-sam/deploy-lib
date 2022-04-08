# меняем в админке урл до старого веб апи

$query = "update UniRu.Settings.SiteOptions
set Value = '/oauth/token'
where Name = 'OAuth.TokenUrl'"

Invoke-Sqlcmd -Database UniRu -Query $query