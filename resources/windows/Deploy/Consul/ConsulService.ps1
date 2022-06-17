$CONSUL_DIR = "C:\Consul"
$consul_distr = "\\server\tcbuild$\testers\consul\consul.exe"
$sname = "Consul"

# Stop consul service, if exists
if (get-service -Name $sname -ErrorAction SilentlyContinue) {
    Write-Host "[INFO] Stop Consul service"
    Stop-Service -Name $sname -Force
    do {
        Start-sleep 1
    }
    until((Get-Service -Name $sname).status -eq 'Stopped')
    start-sleep 1
    Write-Host "[INFO] Delete $sname service"
    SC.EXE DELETE $sname
} else {
    Write-Host "[INFO] Nothing to stop. Consul service does not exist"
}

# Create Consul Folders
if (!(Test-Path $CONSUL_DIR)) {
    Write-Host "[INFO] Create Consul folder"
    New-Item -ItemType Directory -Path "$CONSUL_DIR"
    New-Item -ItemType Directory -Path "$CONSUL_DIR\consul.d"
    New-Item -ItemType Directory -Path "$CONSUL_DIR\data"
    New-Item -ItemType Directory -Path "$CONSUL_DIR\log"
}
else {
    Write-Host "[INFO] $CONSUL_DIR exists"
    Write-Host "[INFO] Remove all data in $CONSUL_DIR"
    Remove-Item -Path "$CONSUL_DIR\*" -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path "$CONSUL_DIR\consul.d"
    New-Item -ItemType Directory -Path "$CONSUL_DIR\data"
    New-Item -ItemType Directory -Path "$CONSUL_DIR\log"
}

# Copy binary from network folder
Write-Host "[INFO] Copy Consul binary to $CONSUL_DIR"
Copy-Item -Path $consul_distr -Destination $CONSUL_DIR -Force
