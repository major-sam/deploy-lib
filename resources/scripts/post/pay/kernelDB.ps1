invoke-sqlcmd -QueryTimeout 720 -database 'BaltbetM'  -ServerInstance LOCALHOST -InputFile  ".\scripts\post\pay\PAY-464.sql" -Verbose
