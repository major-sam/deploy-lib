import-module '.\scripts\sideFunctions.psm1'

$apiPort = '50002'
##Credential provided by jenkins
$username = "$($ENV:SERVICE_CREDS_USR)" 
$pass =  "$($ENV:SERVICE_CREDS_PSW)"
$RuntimeVersion ='v4.0'
$preloader = "SitePreload"
$IISPools = @( 
    @{
        SiteName = 'BaltBet.Payment.BalancingService.Blazor'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:$($apiPort):"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
			rootDir = 'C:\Services\Payments\PaymentBalancing'
		siteSubDir = $true
    }
)  


Import-Module -Force WebAdministration
foreach($site in $IISPools ){
	echo $site
	RegisterIISSite($site)
}
$SiteName = "BaltBet.Payment.BalancingService.Blazor"

Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/anonymousAuthentication' -Name 'enabled' -Value 'false' -PSPath 'IIS:\' -Location $SiteName
Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/windowsAuthentication" -Name 'Enabled' -Value 'True' -PSPath 'IIS:\' -Location $SiteName

