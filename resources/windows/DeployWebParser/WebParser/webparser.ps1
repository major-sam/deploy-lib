import-module '.\scripts\sideFunctions.psm1'

$ServicesFolder = "C:\Services"
$ServiceName = "WebParser"
$PathToConfig = "$($ServicesFolder)\$($ServiceName)\Config"
$PathToExeConfig = "$($ServicesFolder)\$($ServiceName)\WebParser.exe.config"
$rabbitpasswd = $env:RABBIT_CREDS_PSW 
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

Write-Host "[INFO] EDIT WebParser.exe.config..."
[xml]$config = Get-Content -Path $PathToExeConfig
$config.configuration.'system.serviceModel'.services.service |% { if ( $_.name -eq "WebParser.ServiceWebParser")
    {$_.endpoint.address = "http://$($env:COMPUTERNAME):9011"}}

$BaseParserContext = $config.configuration.connectionStrings.add | %{
    if ($_.name -eq "Parser.Base.Line.ParserContext"){
        $_.connectionString =
            "data source=$($env:COMPUTERNAME);"+
            "Integrated Security=SSPI;"+
            "initial catalog=Parser;"+
            "MultipleActiveResultSets=True;"}

    if ($_.name -eq "RabbitConnection"){
        $_.connectionString = 
            "$shortRabbitStr; "+
            "publisherConfirms=true; "
            "timeout=100; " +
            "requestedHeartbeat=0"}

    if ($_.name -eq "RabbitClientAPK"){
        $_.connectionString = 
            "$shortRabbitStr; "+
            "publisherConfirms=true; "+
            "timeout=100; "+
            "requestedHeartbeat=0"}
}
$config.Save($PathToExeConfig)

Write-Host "[INFO] EDIT Settings.xml..."
[xml]$config = Get-Content -Path "$($PathToConfig)\Settings.xml"
$config.Settings.GrpcHost = $env:COMPUTERNAME
$config.Save("$($PathToConfig)\Settings.xml")
