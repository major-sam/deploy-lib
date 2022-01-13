
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$q="
UPDATE [TradingTool].[trading].[settings]
set [Value] = 'http://$($CurrentIpAddr):8444'
Where [key] = 'IMPORT_SERVICE_URL'"
# MARAPHONBETRESULT proxies
$q0 ="
Insert into trading.Proxies (AddedDate, Uri, Username, Password)
Values 
(getdate(),'31.28.11.66:41436','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41437','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41438','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41439','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41440','snekrasov','aPbj5kB')"
$q1 ="
INSERT INTO [trading].[ProxyServices]
SELECT 
	11,
	Id,
	0,
	NULL,
	0
FROM
	[trading].[Proxies]
WHERE [Username] = 'snekrasov'"
Invoke-Sqlcmd -Database 'TradingTool' -query $q -Verbose
Invoke-Sqlcmd -Database 'TradingTool' -query $q0 -Verbose
Invoke-Sqlcmd -Database 'TradingTool' -query $q1 -Verbose
