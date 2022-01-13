<#
    BaltBet.ReportService
    Предоставляет отчётные данные для клиента АПК через WCF
    
    c:\Services\ReportService

    Дополнительно нужный правки в Web.config сайтов "UniRu","baltbetcom","baltbetru"
#>
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$Config = 'C:\Services\ReportService\ReportService.exe.config'
$webdoc = [Xml](Get-Content $Config)
($webdoc.configuration.log4net| %{$_.appender} |? {$_.name -like 'GlobalLogFileAppender'}).file.value =  'c:\Logs\ReportService\'
$webdoc.configuration."system.serviceModel".behaviors.serviceBehaviors.behavior.serviceCredentials.serviceCertificate.findValue = "test.wcf.host"
$webdoc.configuration."system.serviceModel".services |% {$_.service | % { $_.endpoint.address =$_.endpoint.address.replace('localhost', $CurrentIpAddr)}}
$webdoc.Save($Config)

