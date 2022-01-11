import-module '.\scripts\sideFunctions.psm1'

##Credential provided by jenkins
$username = "$($ENV:SERVICE_CREDS_USR)" 
$pass =  "$($ENV:SERVICE_CREDS_PSW)"
$preloader = "SitePreload"
$wildcardDomain = "bb-webapps.com"
$IISPools = @( 
    @{
        sitename = 'UniPaymentsService'
        RuntimeVersion = ''
        domainauth =  @{
            username="$username";password="$pass";identitytype=3
            }
        bindings= @(
                @{protocol='https';bindinginformation="*:54381:$($env:computername).$($wildcarddomain)"}
            )
		certpath = 'cert:\localmachine\my\38be86bcf49337804643a671c4c56bc4224c6606'
		rootdir = 'c:\Services'
		sitesubdir = $true
    }
    @{
        sitename = 'PaymenSystemHandlers'
        RuntimeVersion = 'v4.0'
        domainauth =  @{
            username="$username";password="$pass";identitytype=3
            }
        bindings= @(
                @{protocol='http';bindinginformation="*:88:"}
            )
		rootdir = 'c:\inetpub'
		sitesubdir = $true
    }
    @{
        sitename = 'websitecom'
        RuntimeVersion = 'v4.0'
        domainauth =  @{
            username="$username";password="$pass";identitytype=3
            }
        bindings= @(
                @{protocol='http';bindinginformation="*:84:$($env:computername).$($wildcarddomain)"}
                @{protocol='https';bindinginformation="*:4444:$($env:computername).$($wildcarddomain)"}
            )
		certpath = 'cert:\localmachine\my\38be86bcf49337804643a671c4c56bc4224c6606'
		rootdir = 'c:\inetpub'
		sitesubdir = $true
    }
    @{
        SiteName = 'WebsiteCom-Public'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:4446:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub'
		siteSubDir = $true
    }
    @{
        SiteName = 'Website'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='http';bindingInformation="*:81:$($env:COMPUTERNAME).$($wildcardDomain)"}
                @{protocol='https';bindingInformation="*:4445:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub'
		siteSubDir = $true
    }
    @{
        SiteName = 'KRM'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='http';bindingInformation="*:8080:"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub'
		siteSubDir = $true
    }
    @{
        SiteName = 'UniRu'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:4443:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub\ClientWorkPlace'
		siteSubDir = $true
    }
    @{
        SiteName = 'UniruWebApi'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:4449:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub\ClientWorkPlace'
		siteSubDir = $true
    }
    @{
        SiteName = 'AdminMessageService'
        RuntimeVersion = ''
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:44307:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'C:\Services\PersonalInfoCenter'
		siteSubDir = $true
    }
    @{
        SiteName = 'WebApiAuth'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:449:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub'
		siteSubDir = $true
    }
    @{
        SiteName = 'BaltBet.CupisIntegrationService.Host'
        RuntimeVersion = ''
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:4453:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\services\CupisIntegrationService'
		siteSubDir = $true
    }
    @{
        SiteName = 'BaltBetDomainService'
        RuntimeVersion = ''
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:8004:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub'
		siteSubDir = $true
    }
    @{
        SiteName = 'WebMobile'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:4447:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub'
		siteSubDir = $true
    }
    @{
        SiteName = 'WebTouch'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:446:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub'
		siteSubDir = $true
    }
    @{
        SiteName = 'WebTouch-Public'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:447:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\inetpub'
		siteSubDir = $true
    }
    @{
        SiteName = 'UniStatisticsLogger'
        RuntimeVersion = 'v4.0'
        DomainAuth =  @{
            userName="$username";password="$pass";identitytype=3
            }
        Bindings= @(
                @{protocol='https';bindingInformation="*:13443:$($env:COMPUTERNAME).$($wildcardDomain)"}
            )
		CertPath = 'Cert:\LocalMachine\My\38be86bcf49337804643a671c4c56bc4224c6606'
		rootDir = 'c:\Services'
		siteSubDir = $true
    }
)  



foreach($site in $IISPools ){
   RegisterIISSite($site)
}	


###
# ADD PRELOAD TO UNIRU
###
if ( (C:\Windows\system32\inetsrv\appcmd.exe  list config   -section:system.applicationHost/serviceAutoStartProviders /text:* | Select-String 'name:'| foreach { $_.line } | foreach { $_.ToString() }) -match ".*$preloader.*"){
	write-host(" preloader is allready set")
}else{	
	C:\Windows\system32\inetsrv\AppCmd.exe set config -section:system.applicationHost/serviceAutoStartProviders /+"[name='$preloader',type='Web.ClientWorkspace.SitePreloadClient, Web.ClientWorkspace']" /commit:apphost
}


$WebSiteName = "UniRu"
Set-WebConfigurationProperty -Filter "system.applicationHost/sites/site[@name='$WebSiteName']/applicationDefaults" -Name serviceAutoStartEnabled -Value True
Set-WebConfigurationProperty -Filter "system.applicationHost/sites/site[@name='$WebSiteName']/applicationDefaults" -Name serviceAutoStartProvider -Value $preloader
