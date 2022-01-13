# cleanup inetpub and IIS
## cleanup DB
#$sqlInstanceName = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
#Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
#Install-Module -Name SqlServer -AllowClobber -Force
Import-Module -Name SqlServer -Force
$rQuery =" EXEC sp_MSforeachdb
  'IF DB_ID(''?'') > 4
  BEGIN
    EXEC (''ALTER DATABASE [?] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [?]'' )
  END'
  "
invoke-sqlcmd -ServerInstance $env:computername -Query $rQuery
