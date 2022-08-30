import-module '.\scripts\sideFunctions.psm1'

Write-Host "[INFO] EDIT WebParser.exe.config..."
$ServicesFolder = "C:\Services"
$ServiceName = "WebParser"
$PathToConfig = "$($ServicesFolder)\$($ServiceName)\Config"
$PathToExeConfig = "$($ServicesFolder)\$($ServiceName)\WebParser.exe.config"
$shortRabbitStr="host=$($ENV:RABBIT_HOST);"+
    "username=$($ENV:RABBIT_CREDS_USR);password=$($env:RABBIT_CREDS_PSW)" +
    "publisherConfirms=true;timeout=100;requestedHeartbeat=0"

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

    if ($_.name -ieq "RabbitConnection"){ $_.connectionString = $shortRabbitStr }
    if ($_.name -ieq "RabbitClientAPK"){ $_.connectionString = $shortRabbitStr }
    if ($_.name -ieq "MatchFactRabbit"){ $_.connectionString = $shortRabbitStr }
}
$config.Save($PathToExeConfig)

Write-Host "[INFO] EDIT Settings.xml..."
[xml]$config = Get-Content -Path "$($PathToConfig)\Settings.xml"
$config.Settings.GrpcHost = $env:COMPUTERNAME
$config.Save("$($PathToConfig)\Settings.xml")
