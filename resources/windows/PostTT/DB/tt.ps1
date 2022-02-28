
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$q="
UPDATE [TradingTool].[trading].[settings]
set [Value] = 'http://$($CurrentIpAddr):8444'
Where [key] = 'IMPORT_SERVICE_URL'"
# MARAPHONBETRESULT proxies
$q0 ="
Insert into trading.Proxies (AddedDate, Uri, Username, Password)
Values 
(getdate(),'31.28.11.66:41411','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41412','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41413','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41414','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41415','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41416','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41417','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41418','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41419','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41420','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41421','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41422','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41423','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41424','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41425','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41426','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41427','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41428','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41429','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41430','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41431','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41432','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41433','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41434','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41435','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41436','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41437','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41438','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41439','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41440','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41441','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41442','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41443','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41444','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41445','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41446','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41447','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41448','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41449','snekrasov','aPbj5kB'),
(getdate(),'31.28.11.66:41450','snekrasov','aPbj5kB')"
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
$q2 ="
INSERT INTO [trading].[ProxyServices]
SELECT 
	10,
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
Invoke-Sqlcmd -Database 'TradingTool' -query $q2 -Verbose
