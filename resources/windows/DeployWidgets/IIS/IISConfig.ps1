import-module '.\scripts\sideFunctions.psm1'

write-host 'config iis for BaltWidgetsClient' 

$username = "$($ENV:SERVICE_CREDS_USR)" 
$pass =  "$($ENV:SERVICE_CREDS_PSW)"
$RuntimeVersion =''
$wildcardDomain = "bb-webapps.com"
$site = @{
    SiteName = 'BaltWidgetsClient'
    RuntimeVersion = $RuntimeVersion
    DomainAuth =  @{
        userName="$username";password="$pass";identitytype=3
        }
    Bindings= @(
            @{protocol='https';;bindingInformation="$($env:COMPUTERNAME).$($wildcardDomain):450:"}
        )
    CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
    rootDir = 'C:\Services\BaltWidgets\BaltWidgetsClient'
    siteSubDir = $false
}

RegisterIISSite($site)