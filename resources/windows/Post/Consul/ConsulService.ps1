$CONSUL_DIR = "C:\Consul"

$passVar = ConvertTo-SecureString $ENV:SERVICE_CREDS_PSW -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($ENV:SERVICE_CREDS_USR , $passVar)

$params = @{
    Name           = "Consul"
    BinaryPathName = "$CONSUL_DIR\consul.exe agent -dev -ui"
    DisplayName    = "Consul"
    StartupType    = "Automatic"
    Description    = "Consul Hashicorp Service - DEV mode"
}


# Register Consul as a WindowsService
if (!(get-service -Name $params.Name -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] Add $CONSUL_DIR path to ENV"
    $env:path += ";${CONSUL_DIR}"
    [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "Machine") + ";${CONSUL_DIR}", "Machine")
    Write-Host "[INFO] Register Consul service"
    New-Service @params
    Write-Host "[INFO] Set $params.Name credentials"
    $service = gwmi win32_service -filter "name='$params.Name'"
    $service.Change($Null, $Null, $Null, $Null, $Null, $Null, $ENV:SERVICE_CREDS_USR, $ENV:SERVICE_CREDS_PSW) | Out-Null
    return $params.Name
}
else {
    Write-Host "[INFO] Consul service already exists"
}
Write-Host "[INFO] Starting Consul service in DEV mode"
Start-Service -Name $params.Name
