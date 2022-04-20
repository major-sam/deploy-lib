$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$clientConfig = 'C:\ApkClient\Client.exe.config'
$vmhostname= ($env:COMPUTERNAME).ToLower()
$PaymentBalanceServiceUrl = "https://$($vmhostname).bb-webapps.com:50009"
$DomainServiceUrl = "https://$($vmhostname).bb-webapps.com:8004/api/domains/get/all?active=true"
$BaltSportStatisticService = "https://$($CurrentIpAddr):9014/" 
$TicketService = "http://$($CurrentIpAddr):5037/" 
$BookmakerService = "http://$($CurrentIpAddr):8401/" 
$BetSpanParserUrl_v2 ="http://$($CurrentIpAddr):8098/" 
if (Test-Path $clientConfig){
    (Get-content -raw $clientConfig).Replace(
        'net.tcp://localhost',"net.tcp://$CurrentIpAddr").Replace(
            "wcf.kernel.host","test.wcf.host") | Set-Content $clientConfig
    $xmlconfig = [Xml](Get-Content $clientConfig)
    ($xmlconfig.configuration.connectionStrings.add| ? {
        $_.name -ilike 'BaltSportStatisticService'}).connectionString = $BaltSportStatisticService
    ($xmlconfig.configuration.connectionStrings.add| ? {
        $_.name -ilike 'TicketService'}).connectionString = $TicketService
    ($xmlconfig.configuration.connectionStrings.add| ? {
        $_.name -ilike 'BookmakerService'}).connectionString = $BookmakerService
    ($xmlconfig.configuration.appSettings.add| ? {
        $_.key -ilike 'BetSpanParserUrl_v2'}).value = $BetSpanParserUrl_v2
    ($xmlconfig.configuration.appSettings.add| ? {
        $_.key -ilike 'PaymentBalanceServiceUrl'}).value = $PaymentBalanceServiceUrl
    ($xmlconfig.configuration.appSettings.add| ? {
        $_.key -ilike 'DomainServiceUrl'}).value = $DomainServiceUrl
    ($xmlconfig.configuration.'system.serviceModel'.client.endpoint| ? {
        $_.name -ilike 'StatisticsWCFService'}).address = "http://localhost:30000/"
    $xmlconfig.Save($clientConfig)
}
else{
    Write-Host "$clientConfig not exists"}

