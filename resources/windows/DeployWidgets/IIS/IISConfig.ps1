import-module '.\scripts\sideFunctions.psm1'

write-host 'config iis for BaltWidgetsClient' 

$username = "$($ENV:SERVICE_CREDS_USR)" 
$pass = "$($ENV:SERVICE_CREDS_PSW)"
$RuntimeVersion = ''
$wildcardDomain = "bb-webapps.com"

$IISPools = @(
    @{
        SiteName       = 'BaltWidgetsClient'
        RuntimeVersion = $RuntimeVersion
        DomainAuth     = @{
            userName = "$username"; password = "$pass"; identitytype = 3
        }
        Bindings       = @(
            @{protocol = 'https'; ; bindingInformation = "*:450:$($env:COMPUTERNAME).$($wildcardDomain)" }
        )
        CertPath       = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
        rootDir        = 'C:\Services\BaltWidgets\BaltWidgetsClient'
        siteSubDir     = $false
    }
    @{
        SiteName       = 'BaltWidgetService'
        RuntimeVersion = $RuntimeVersion
        DomainAuth     = @{
            userName = "$username"; password = "$pass"; identitytype = 3
        }
        Bindings       = @(
            @{protocol = 'https'; ; bindingInformation = "*:6001:$($env:COMPUTERNAME).$($wildcardDomain)" }
        )
        CertPath       = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
        rootDir        = 'C:\Services\BaltWidgets\BaltWidgetsService'
        siteSubDir     = $false
    }
)

foreach ($site in $IISPools) {
    Write-host "[INFO] Config IIS for $($site.SiteName)"
    if (test-path($site.rootDir)) {
        RegisterIISSite($site)
    }
    else {
        Write-host "[WARN] $($site.rootDir) does not exist. Skip IIS registration."
    }
}
