UPDATE UniAdministration.Settings.SiteOptions 
SET [Value] = '/oauth/token'
    WHERE Name = 'OAuth.TokenUrl'
    