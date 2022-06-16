$CONSUL_DIR = "C:\Consul"
$consul_distr = "\\server\tcbuild$\testers\consul\consul.exe"

$params = @{
    Name           = "Consul"
    BinaryPathName = "$CONSUL_DIR\consul.exe agent -dev -ui"
    DisplayName    = "Consul"
    StartupType    = "Automatic"
    Description    = "Consul Hashicorp Service - DEV mode"
}

# Stop consul service, if exists
if (get-service -Name $params.Name -ErrorAction SilentlyContinue) {
    Write-Host "[INFO] Stop Consul service"
    Stop-Service -Name $params.Name -Force
    do {
        Start-sleep 1
    }
    until((Get-Service -Name $params.name).status -eq 'Stopped')
    start-sleep 1
    Write-Host "[INFO] Delete $params.Name service"
    SC.EXE DELETE $params.Name
} else {
    Write-Host "[INFO] Nothing to stop. Consul service does not exist"
}

# Create Consul Folder
if (!(Test-Path $CONSUL_DIR)) {
    Write-Host "[INFO] Create Consul folder"
    New-Item -ItemType Directory $CONSUL_DIR
}
else {
    Write-Host "[INFO] $CONSUL_DIR exists"
}

# Copy binary from network folder
Write-Host "[INFO] Copy Consul binary to $CONSUL_DIR"
Copy-Item -Path $consul_distr -Destination $CONSUL_DIR -Force
