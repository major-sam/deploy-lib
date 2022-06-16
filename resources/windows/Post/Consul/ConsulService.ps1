$CONSUL_DIR = "C:\Consul"

$passVar = ConvertTo-SecureString $ENV:SERVICE_CREDS_PSW -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($ENV:SERVICE_CREDS_USR , $passVar)

$params = @{
    Name           = "Consul"
    BinaryPathName = "$CONSUL_DIR\consul.exe agent -bind=`"0.0.0.0`" -client=`"0.0.0.0`" -dev -ui"
    DisplayName    = "Consul"
    StartupType    = "Automatic"
    Description    = "Consul Hashicorp Service - DEV mode"
}

$sname = $params.Name

# Register Consul as a WindowsService
if (!(get-service -Name $sname -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] Add $CONSUL_DIR path to ENV"
    $env:path += ";${CONSUL_DIR}"
    [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "Machine") + ";${CONSUL_DIR}", "Machine")
    Write-Host "[INFO] Register Consul service"
    New-Service @params
    Write-Host "[INFO] Set $sname credentials"
    $service = gwmi win32_service -filter "name='$sname'"
    $service.Change($Null, $Null, $Null, $Null, $Null, $Null, $ENV:SERVICE_CREDS_USR, $ENV:SERVICE_CREDS_PSW) | Out-Null
    return $sname
}
else {
    Write-Host "[INFO] Consul service already exists"
}
Write-Host "[INFO] Starting Consul service in DEV mode"
Start-Service -Name $sname
