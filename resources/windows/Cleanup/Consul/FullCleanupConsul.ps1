$CONSUL_DIR = "C:\Consul"
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

# Cleanup Consul Folders
if ((Test-Path $CONSUL_DIR)) {
    Write-Host "[INFO] $CONSUL_DIR exists"
    Write-Host "[INFO] Remove $CONSUL_DIR"
    Remove-Item -Path $CONSUL_DIR -Recurse -Force -ErrorAction SilentlyContinue
}
else {
    Write-Host "[INFO] $CONSUL_DIR does not exist. Nothing to cleanup."
}