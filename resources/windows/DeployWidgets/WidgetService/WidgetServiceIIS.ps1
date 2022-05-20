import-module '.\scripts\sideFunctions.psm1'


$username = "$($ENV:SERVICE_CREDS_USR)" 
$pass = "$($ENV:SERVICE_CREDS_PSW)"
$RuntimeVersion = ''
$wildcardDomain = "bb-webapps.com"

$site = @{
    SiteName       = 'WidgetService'
    RuntimeVersion = $RuntimeVersion
    DomainAuth     = @{
        userName = "$username"; password = "$pass"; identitytype = 3
    }
    Bindings       = @(
        @{protocol = 'https'; ; bindingInformation = "*:6001:$($env:COMPUTERNAME).$($wildcardDomain)" }
    )
    CertPath       = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
    rootDir        = 'C:\Services\BaltWidgets\WidgetService'
    siteSubDir     = $false
}

Write-host "[INFO] Config IIS for $($site.SiteName)"

if (test-path($site.rootDir)) {
    RegisterIISSite($site)
} else {
    Write-host "[WARN] $($site.rootDir) does not exist. Skip IIS registration."
}