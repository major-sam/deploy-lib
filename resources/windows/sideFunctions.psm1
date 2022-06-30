function Format-Json {
    <#
    .SYNOPSIS
        Prettifies JSON output.
    .DESCRIPTION
        Reformats a JSON string so the output looks better than what ConvertTo-Json outputs.
    .PARAMETER Json
        Required: [string] The JSON text to prettify.
    .PARAMETER Minify
        Optional: Returns the json string compressed.
    .PARAMETER Indentation
        Optional: The number of spaces (1..1024) to use for indentation. Defaults to 4.
    .PARAMETER AsArray
        Optional: If set, the output will be in the form of a string array, otherwise a single string is output.
    .EXAMPLE
        $json | ConvertTo-Json  | Format-Json -Indentation 2
    #>
    [CmdletBinding(DefaultParameterSetName = 'Prettify')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Json,

        [Parameter(ParameterSetName = 'Minify')]
        [switch]$Minify,

        [Parameter(ParameterSetName = 'Prettify')]
        [ValidateRange(1, 1024)]
        [int]$Indentation = 4,

        [Parameter(ParameterSetName = 'Prettify')]
        [switch]$AsArray
    )

    if ($PSCmdlet.ParameterSetName -eq 'Minify') {
        return ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100 -Compress
    }

    # If the input JSON text has been created with ConvertTo-Json -Compress
    # then we first need to reconvert it without compression
    if ($Json -notmatch '\r?\n') {
        $Json = ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100
    }

    $indent = 0
    $regexUnlessQuoted = '(?=([^"]*"[^"]*")*[^"]*$)'

    $result = $Json -split '\r?\n' |
        ForEach-Object {
            # If the line contains a ] or } character, 
            # we need to decrement the indentation level unless it is inside quotes.
            if ($_ -match "[}\]]$regexUnlessQuoted") {
                $indent = [Math]::Max($indent - $Indentation, 0)
            }

            # Replace all colon-space combinations by ": " unless it is inside quotes.
            $line = (' ' * $indent) + ($_.TrimStart() -replace ":\s+$regexUnlessQuoted", ': ')

            # If the line contains a [ or { character, 
            # we need to increment the indentation level unless it is inside quotes.
            if ($_ -match "[\{\[]$regexUnlessQuoted") {
                $indent += $Indentation
            }

            $line
        }

    if ($AsArray) { return $result }
    return ($result -Join [Environment]::NewLine)
}

function XmlDocTransform($xml, $xdt){
    
    if (!$xml -or !(Test-Path -path $xml -PathType Leaf)) {
        throw "File not found. $xml";
    }
    if (!$xdt -or !(Test-Path -path $xdt -PathType Leaf)) {
        throw "File not found. $xdt";
    }

    #$scriptPath = (Get-Variable MyInvocation -Scope 1).Value.InvocationName | split-path -parent
    Add-Type -LiteralPath $transformLibPath

    $xmldoc = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument;
    $xmldoc.PreserveWhitespace = $true
    $xmldoc.Load($xml);

    $transf = New-Object Microsoft.Web.XmlTransform.XmlTransformation($xdt);
    if ($transf.Apply($xmldoc) -eq $false)
    {
        throw "Transformation failed."
    }
    $xmldoc.Save($xml);
}

function RestoreSqlDb($db_params) {	
	#load assemblies
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
	$MSSQLDataPath =  (Invoke-Sqlcmd -query "select SERVERPROPERTY('InstanceDefaultDataPath') as 'd'").d
	write-output "mssql data:" $MSSQLDataPath
	foreach ($db in $db_params){
		$RelocateFile = @() 
        $dt = Invoke-Sqlcmd "restore filelistonly from disk='$($db.BackupFile)'"
        $dbname = $db.DbName
        foreach ($r in $dt){
            $RelocateFile += New-Object Microsoft.SqlServer.Management.Smo.RelocateFile(
                    $r.LogicalName , ("{0}{1}_{2}" -f $MSSQLDataPath,$dbname,$r.LogicalName)
                )
        }
        Restore-SqlDatabase -Verbose -ServerInstance $env:COMPUTERNAME -Database $db.DbName -BackupFile $db.BackupFile -RelocateFile $RelocateFile -ReplaceDatabase
        Push-Location C:\Windows			
## legacy		if ($db.ContainsKey('RelocateFiles')){
## legacy			foreach ($dbFile in $db.RelocateFiles) {
## legacy				$RelocateFile += New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($dbFile.SourceName, ("{0}{1}" -f $MSSQLDataPath, $dbFile.FileName))
## legacy			}
## legacy            write-output $db.BackupFile
## legacy			Push-Location C:\Windows
## legacy		}else{
## legacy			Restore-SqlDatabase -Verbose -ServerInstance $env:COMPUTERNAME -Database $db.DbName -BackupFile $db.BackupFile -ReplaceDatabase
## legacy			Push-Location C:\Windows			
## legacy		}
	}
}

function GetSourceObject($itm) {    
	$json = Get-Content -Raw -path $itm.sourceFile | ConvertFrom-Json
	$obj = $json |?{ $_.name -eq $itm.sourceName}
	return $obj
}

function CreateSqlDatabase($dbname){
	[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
	$server = new-object ("Microsoft.SqlServer.Management.Smo.Server") .

    $dbExists = $FALSE
	foreach ($db in $server.databases) {
		if ($db.name -eq $dbname) {
		  Write-output "Db $dbname already exists."
		  $dbExists = $TRUE
		}
	}
	if ($dbExists -eq $FALSE) {
	  $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -argumentlist $server, $dbname
	  $db.Create()
	}
}

function RegisterIISSite($site){
    Import-Module -Force WebAdministration
    $name =  $site.SiteName
    $runtimeVersion = $site.RuntimeVersion
	if ($site.siteSubDir){
		$targetDir = Join-Path -path $site.rootDir -childpath $name
	}else{
		$targetDir = "$($site.rootDir)"
	}
    if (Test-Path IIS:\AppPools\$name){
        Write-output "SITE EXIST!!!"
    }
    else{
        New-Item -Path IIS:\AppPools\$name -force
        Set-ItemProperty -Path IIS:\AppPools\$name -Name managedRuntimeVersion -Value $runtimeVersion
        Set-ItemProperty -Path IIS:\AppPools\$name -Name startMode -Value 'AlwaysRunning'
        if ($site.DomainAuth){
           Set-ItemProperty  IIS:\AppPools\$name -name processModel -value $site.DomainAuth
        }
        Start-WebAppPool -Name $name
        New-Website -Name "$name" -ApplicationPool "$name" -PhysicalPath $targetDir -Force
        $IISSite = "IIS:\Sites\$name"
        Set-ItemProperty $IISSite -name  Bindings -value $site.Bindings
        $bind = Get-WebBinding -Name $name -Protocol https
        if($bind){
            $webServerCert = get-item $site.CertPath
            $bind.AddSslCertificate($webServerCert.GetCertHashString(), "my")		
        }
        Start-WebSite -Name "$name"
        Start-WebAppPool -Name "$name"
    }
}

function RegisterWinService_v2{
    <#
        .SYNOPSIS
        Register windows service.
        .DESCRIPTION
        Register Service function(ASP 3+ service update)
        .PARAMETER Service
        Path to service binary
        .PARAMETER UserName
        Service creds(default provided by jenkins)
        .PARAMETER Password
        Service creds(default provided by jenkins)
        .PARAMETER AddExecDisplayName
        add displayName param as binary kwargs(for topshelf)
        .PARAMETER AddExecServiceName
        add serviceName param as binary kwargs(for topshelf)
        .PARAMETER AddExecContentRoot
        add contentroot param as binary kwargs(for ASP.core)
        .PARAMETER ServiceBinParams 
        extra args&kwargs for binary
        .PARAMETER ServiceParams
        extra params for New-Service powershell cmdlet
        .EXAMPLE
        C:\PS>RegisterWinService_v2 -Service '\myservice\myservice.exe' -username test -password TesT -AddExecContentRoot $true  
        .NOTES
        Author: vrebiachikh
        Date:   24.06.2022
#>
    param(
        [object]
        [Parameter(Mandatory,HelpMessage='Path to binary')]
            $Service,
        [string]
            $UserName = $ENV:SERVICE_CREDS_USR,
        [string]
            $Password = $ENV:SERVICE_CREDS_PSW,
        [bool]
            $AddExecDisplayName = $true,
        [bool]
            $AddExecServiceName = $true,
        [bool]
            $AddExecContentRoot = $false,
        [string]
            $ServiceBinParams = '',
        [string]
            $ServiceParams = '')

    if ($Service.GetType() -eq [string] ) {
        $ServiceBin = Get-item $Service}
    elseif($Service.GetType() -in ( [System.IO.FileSystemInfo], [System.IO.FileInfo] )){
        $ServiceBin = $Service}
    else{
        Write-Error 'The var type not supported.V alid types: String,FileSystemInfo' -ErrorAction Stop}

    if ($serviceBin.BaseName -like 'baltbet*'){$sname = "$($serviceBin.BaseName)" }
    else{$sname = "Baltbet.$($serviceBin.BaseName)"}
    if ($AddExecDisplayName){$ServiceBinParams += " --DisplayName `"$sname`""}
    if ($AddExecServiceName){$ServiceBinParams += " --ServiceName `"$snane`""}
    if ($AddExecContentRoot){$ServiceBinParams += " --ContentRoot `"$($ServiceBin.Directory.FullName)`""}

    [String]$BinStr = "$($ServiceBin.FullName) $ServiceBinParams"

    write-host "Add new service $sname with bin params: $BinStr"
    if ([string]::IsNullOrEmpty($ServiceParams)){
        New-Service -name $sname -BinaryPathName $BinStr -DisplayName $sname | OUT-Null
    }else{
        New-Service -name $sname -BinaryPathName $BinStr -DisplayName $sname $ServiceParams| OUT-Null
    }
    $service = gwmi win32_service -filter "name='$sname'"
    $service.Change($Null, $Null, $Null, $Null, $Null, $Null, $UserName, $Password)| Out-Null
    return $sname
}

function RegisterWinService($serviceBin){
	##Credential provided by jenkins
	write-host "Register service:"
	$passVar = ConvertTo-SecureString $ENV:SERVICE_CREDS_PSW -AsPlainText -Force
	$credentials = New-Object System.Management.Automation.PSCredential ($ENV:SERVICE_CREDS_USR , $passVar )
	if ($($serviceBin.BaseName)  -like 'baltbet*'){
		$sname = "$($serviceBin.BaseName)"
		
	}
	else{
		$sname = "Baltbet.$($serviceBin.BaseName)"
	}
	write-host "add new service $sname"
	New-Service -name $sname -BinaryPathName "$($serviceBin.FullName)  -displayname `"$sname`" -servicename `"$sname`"" -DisplayName $sname | OUT-Null
	write-host "set $sname credentials"
	$service = gwmi win32_service -filter "name='$sname'"
	$service.Change($Null, $Null, $Null, $Null, $Null, $Null, $ENV:SERVICE_CREDS_USR, $ENV:SERVICE_CREDS_PSW)| Out-Null
	return $sname
}

function Stop-ServiceWithTimeout($name) {
	$timespan = New-Object -TypeName System.Timespan -ArgumentList 0,0,10
	$svc = Get-Service -Name $name
	if ($svc -eq $null) { return $false }
	if ($svc.Status -eq [ServiceProcess.ServiceControllerStatus]::Stopped) { return $true }
	$svc.Stop()
	try {
		$svc.WaitForStatus([ServiceProcess.ServiceControllerStatus]::Stopped, $timespan)
	}
	catch [ServiceProcess.TimeoutException] {
		Write-Verbose "Timeout stopping service $($svc.Name)"
		Stop-Process -Name $name -Force
	}
}

function Set-Recovery{
	param
		(
		 [string] [Parameter(Mandatory=$true)] $ServiceDisplayName,
		 [string] [Parameter(Mandatory=$true)] $Server,
		 [string] $action1 = "restart",
		 [int] $time1 =  30000, # in miliseconds
		 [string] $action2 = "restart",
		 [int] $time2 =  30000, # in miliseconds
		 [string] $actionLast = "restart",
		 [int] $timeLast = 30000, # in miliseconds
		 [int] $resetCounter = 4000 # in seconds
		)
		$serverPath = "\\" + $server
		$services = Get-CimInstance -ClassName 'Win32_Service' | Where-Object {
            $_.DisplayName -imatch $ServiceDisplayName}
        $action = $action1+"/"+$time1+"/"+$action2+"/"+$time2+"/"+$actionLast+"/"+$timeLast

		foreach ($service in $services){
# https://technet.microsoft.com/en-us/library/cc742019.aspx
             $output = sc.exe $serverPath failure $($service.Name) actions= $action reset= $resetCounter
		 }
	 }

function ApplyTasks{
    param (
         [string] [Parameter(Mandatory=$true)] $ScriptFolder,
         [string] [Parameter(Mandatory=$true)] $TargetDB,
		 [int] $QueryTimeout = 720, # in seconds
         [string] $DBServer = 'localhost',
         [string] $extension = 'sql'
         )

    if (Test-Path $ScriptFolder) {
        $scriptArray = (Get-Item -Path $ScriptFolder\* -Include "*.$extension").FullName 
        if ($scriptArray -ne $null){
            foreach ($script in $scriptArray | Sort-Object ) {    
                Write-Host -ForegroundColor Green "[INFO] Execute $script on $TargetDB"
                Invoke-Sqlcmd `
                    -verbose `
                    -QueryTimeout $QueryTimeout `
                    -ServerInstance $DBServer`
                    -Database $TargetDB `
                    -InputFile $script `
                    -ErrorAction stop
            }
        }
        else{
            Write-Host -ForegroundColor Yellow "[INFO] There is no Tasks for this build"
        }
    } else {
        Write-Host -ForegroundColor Yellow "[INFO] There is no Tasks folder"
    }
}
