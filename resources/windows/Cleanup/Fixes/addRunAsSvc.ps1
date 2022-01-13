if($env:HOMEDRIVE -like 'z:') {
	$ENV:HOMEDRIVE='C:'
	restart-service RabbitMQ 
	start-sleep 7
}
#$usernames = @("GKBALTBET\TestKernel_svc")
#
#foreach($username in $usernames){
#	$tempPath = [System.IO.Path]::GetTempPath()
#	$import = Join-Path -Path $tempPath -ChildPath "import.inf"
#	if(Test-Path $import) { Remove-Item -Path $import -Force }
#	$export = Join-Path -Path $tempPath -ChildPath "export.inf"
#	if(Test-Path $export) { Remove-Item -Path $export -Force }
#	$secedt = Join-Path -Path $tempPath -ChildPath "secedt.sdb"
#	if(Test-Path $secedt) { Remove-Item -Path $secedt -Force }
#	try {
#		$sid = ((New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier])).Value
#		secedit /export /cfg $export
#		$sids = (Select-String $export -Pattern "SeServiceLogonRight").Line
#		foreach ($line in @("[Unicode]", "Unicode=yes", "[System Access]", "[Event Audit]", "[Registry Values]", "[Version]", "signature=`"`$CHICAGO$`"", "Revision=1", "[Profile Description]", "Description=GrantLogOnAsAService security template", "[Privilege Rights]", "$sids,*$sid")){
#		  Add-Content $import $line
#		}
#		secedit /import /db $secedt /cfg $import
#		secedit /configure /db $secedt
#		Remove-Item -Path $import -Force
#		Remove-Item -Path $export -Force
#		Remove-Item -Path $secedt -Force
#	} catch {
#		$error[0]
#	}
#}
## temp 3.1 fix
##choco install dotnetcore-3.1-windowshosting -y
#choco install dotnetcore-3.1-runtime -y
#choco install dotnet-6.0-runtime -y
#choco install dotnet-6.0-windowshosting -y
$fixNameQuery= "
DECLARE @MachineName NVARCHAR(60)
SET @MachineName = CONVERT(nvarchar,SERVERPROPERTY('ServerName'));

IF @MachineName IS NULL
BEGIN
	PRINT 'Could not retrieve machine name using SERVERPROPERTY!';
	GOTO Quit;
END

DECLARE @CurrSrv VARCHAR(MAX)
SELECT @CurrSrv = name FROM sys.servers WHERE server_id = 0;

IF @CurrSrv = @MachineName
BEGIN
	PRINT 'Server name already matches actual machine name.'
	GOTO Quit;
END

IF @CurrSrv IS NOT NULL
BEGIN
	PRINT 'Dropping local server name ' + @CurrSrv
	EXEC sp_dropserver @CurrSrv
END

IF EXISTS (SELECT 1 FROM sys.servers WHERE server_id <> 0 AND [name] = @MachineName)
BEGIN
	PRINT 'The local server is incorrectly configured as a remote server. Dropping server name ' + @MachineName
	EXEC sp_dropserver @MachineName
END

PRINT 'Creating local server name ' + @MachineName
EXEC sp_addserver @MachineName, local

Quit:

IF EXISTS (SELECT [name] FROM sys.servers WHERE server_id = 0 AND [name] <> @@SERVERNAME)
	OR (@MachineName IS NOT NULL AND (@@SERVERNAME <> CONVERT(NVARCHAR,SERVERPROPERTY('ServerName'))))
	PRINT 'Your server name was changed. Please restart the SQL Server service to apply changes.';

"
$qw = (Invoke-Sqlcmd -Query $fixNameQuery -ServerInstance $Server -verbose) 4>&1
if($qw.Message.Contains("Server name already matches actual machine name")){
 Write-Host $qw.Message
}
else{
Restart-Service MSSQLSERVER -Force
}

# Удаляем старый сертификат test.wcf.host.pfx с отпечатком A79B6EC79FCC529D73ABC686D041C402D638CFCF
Write-Host -ForegroundColor Green "[INFO] Remove old test.wcf.host.pfx certificate..."
$cert_old = Test-Path -Path Cert:\LocalMachine\My\A79B6EC79FCC529D73ABC686D041C402D638CFCF
if ($cert_old) {
    Get-ChildItem Cert:\LocalMachine\My\A79B6EC79FCC529D73ABC686D041C402D638CFCF | Remove-Item
} else {
    Write-Host -ForegroundColor Green "[INFO] Old test.wcf.host.pfx certificate doesn't exist"
}
