import-module '.\scripts\sideFunctions.psm1'

write-host 'config iis for ms' 

##Credential provided by jenkins
$username = "$($ENV:SERVICE_CREDS_USR)" 
$pass =  "$($ENV:SERVICE_CREDS_PSW)"
$RuntimeVersion ='v4.0'
$preloader = "SitePreload"
$IISPools = @( 
    @{
        SiteName = 'MarketingService'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='http';bindingInformation="*:8880:"}
                @{protocol='https';;bindingInformation="*:9880:"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'C:\Services\Marketing\BaltBet.MarketingService'
		siteSubDir = $false
    }
    @{
        SiteName = 'MarketingImages'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='http';bindingInformation="*:8883:"}
                @{protocol='https';bindingInformation="*:9883:"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub\MarketingImages'
		siteSubDir = $false
    }
    @{
        SiteName = 'MarketingServiceAdmin'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='http';bindingInformation="*:8881:"}
                @{protocol='https';bindingInformation="*:9881:"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\services\marketing\BaltBet.MarketingService.Admin'
		siteSubDir = $false
    }
    @{
        SiteName = 'MarketingServiceClient'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='http';bindingInformation="*:8882:"}
                @{protocol='https';bindingInformation="*:9882:"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\services\marketing\BaltBet.MarketingService.Client'
		siteSubDir = $false
    }
)  



Import-Module -Force WebAdministration
foreach($site in $IISPools ){
	RegisterIISSite($site)
}
