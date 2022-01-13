& 'C:\Services\TradingTool\Tools\Baltbet.TradingTool.Database.Updater\Baltbet.TradingTool.Database.Updater.exe'|
  %{ 
	  Write-output $_
      if ($_ -like "Press enter for exit"){
         [Environment]::Exit(0)
           } 
             } 


$updateImportUrl = "
UPDATE [TradingTool].[trading].[settings]
SET [Value] = 'http://$($IpAddr):8444'
WHERE [Key] = 'IMPORT_SERVICE_URL';
"

Invoke-Sqlcmd -Database $dbname  -query $updateImportUrl
