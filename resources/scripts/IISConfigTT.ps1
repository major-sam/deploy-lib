import-module '.\scripts\sideFunctions.psm1'

write-host 'config iis for TT' 
$apiPort = '50005'
##Credential provided by jenkins
$username = "$($ENV:SERVICE_CREDS_USR)" 
$pass =  "$($ENV:SERVICE_CREDS_PSW)"
$RuntimeVersion ='v4.0'
$preloader = "SitePreload"
$IISPools = @( 
    @{
        SiteName = 'Baltbet.TradingTool.Api'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='http';bindingInformation="*:$($apiPort):"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'C:\Services\TradingTool\Services'
		siteSubDir = $true
    }
)  


Import-Module -Force WebAdministration
foreach($site in $IISPools ){
	echo $site
	RegisterIISSite($site)
}
