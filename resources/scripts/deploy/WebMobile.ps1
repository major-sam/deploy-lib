import-module '.\scripts\sideFunctions.psm1'

# 3 Сервис WebMobile

#get release params
$SiteFolder = "C:\inetpub\WebMobile"
$SiteConfig = "$SiteFolder\Web.config"
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()

# Change Web.config
Write-Host -ForegroundColor Green "[INFO] Edit web.config of WebMobile"
$webdoc = [Xml](Get-Content $SiteConfig)
$webdoc.configuration.appSettings.add | % { if ($_.key -eq "MobileServerAddress") {  
        $_.value = "$($CurrentIpAddr):8082"
    }
}
$webdoc.configuration.appSettings.add | % { if ($_.key -eq "SiteServerAddress") {  
        $_.value = "$($CurrentIpAddr):8088"
    }
}
$webdoc.configuration.appSettings.add | % { if ($_.key -eq "ServerAddress") {  
        $_.value = "$($CurrentIpAddr):8082"
    }
}
$webdoc.Save($SiteConfig)
