import-module '.\scripts\sideFunctions.psm1'


###vars
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

$ProgressPreference = 'SilentlyContinue'

$release_bak_folder = "\\server\tcbuild`$\Testers\DB\For WebApi"

$Dbname =  "WebApi.Auth"
$dbs = @(
	@{
		DbName = $Dbname
		BackupFile = "$release_bak_folder\WebApiAuth.bak" 
        RelocateFiles = @(
			@{
				SourceName = "WebApi.Auth"
				FileName = "WebApi.Auth.mdf"
			}
			@{
				SourceName = "WebApi.Auth_log"
				FileName = "WebApi.Auth_log.ldf"
			}
		)    
	}
)

###Create dbs
Write-Host -ForegroundColor Green "[INFO] Create dbs"
RestoreSqlDb -db_params $dbs


$oldIp = '#VM_IP'
$oldHostname = '#VM_HOSTNAME'
$oldDbname =  "#DB_NAME"

$sourceFile = "$($env:workspace)\scripts\deploy\WebApiAuth.sql"
$query = (Get-Content -Encoding UTF8 -Raw -Path $sourceFile)|Foreach-Object {
    $_ -replace $oldIp,  $IPAddress `
        -replace $oldHostname, $env:COMPUTERNAME `
		-replace $oldDbname , $Dbname
    } 
Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database $DbName -query $query -ErrorAction Stop

###
#XML values replace UniRu
####
Write-Host -ForegroundColor Green "[INFO] Edit web.config of $webConfig"
$webConfig = "c:\inetpub\WebApiAuth\Web.config"
$webdoc = [Xml](Get-Content $webConfig)
$webdoc.configuration.connectionStrings.add | % {if ($_.name -eq 'OAuth.LastLogoutUrl') {
		$_.connectionString = "https://$($env:COMPUTERNAME).bb-webapps.com:449/account/logout/last"}}
$webdoc.Save($webConfig)


Write-Host -ForegroundColor Green "[INFO] Done"
