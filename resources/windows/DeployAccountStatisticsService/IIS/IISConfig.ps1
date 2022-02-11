import-module '.\scripts\sideFunctions.psm1'

Write-Host "[INFO] BaltBet.AccountStatisticsService.Host IIS registration" 

$username = "$($ENV:SERVICE_CREDS_USR)" 
$pass =  "$($ENV:SERVICE_CREDS_PSW)"
$RuntimeVersion =''
$wildcardDomain = "bb-webapps.com"
$site = @{
    SiteName = 'BaltBet.AccountStatisticsService.Host'
    RuntimeVersion = $RuntimeVersion
    DomainAuth =  @{
        userName="$username";password="$pass";identitytype=3
        }
    Bindings= @(
            @{protocol='https';;bindingInformation="*:4436:$($env:COMPUTERNAME).$($wildcardDomain)"}
        )
    CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
    rootDir = 'C:\Services\AccountStatisticsService\BaltBet.AccountStatisticsService.Host'
    siteSubDir = $false
}

RegisterIISSite($site)