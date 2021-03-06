$svcs = (invoke-sqlcmd -Query "sp_linkedservers").SRV_NAME
if($svcs.contains("srvapkbb5.gkbaltbet.local")){ 
    $svcs
    Write-Host "srvapkbb5.gkbaltbet.local allready linked"
}
else{
    invoke-sqlcmd -Query "sp_addlinkedserver  [srvapkbb5.gkbaltbet.local]" | Out-Null
}


$q = invoke-sqlcmd -Query "select * from sys.server_principals where name like '$ENV:TT_SERVICE_CREDS_USR'"


if ($q){
    write-host $q.name
}
else{    $conn = New-Object Microsoft.SqlServer.Management.Common.ServerConnection -ArgumentList $env:ComputerName
    $conn.applicationName = "PowerShell SMO"
    $conn.ServerInstance = "$env:ComputerName"
    $conn.StatementTimeout = 0
    $conn.Connect()
    $smo = New-Object Microsoft.SqlServer.Management.Smo.Server -ArgumentList $conn
    $SqlUser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $smo,$ENV:TT_SERVICE_CREDS_USR
    $SqlUser.LoginType = 'WindowsUser'
    $sqlUser.PasswordPolicyEnforced = $false
    $SqlUser.Create()
    $sqlUser.AddToRole("sysadmin")
    $sqlUser.Alter()
    write-host "done"    
}
