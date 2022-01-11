import-module '.\scripts\sideFunctions.psm1'


$serviceblock = {
  Param($service)
   IF ($service.Status -eq 'Running'){
	 Write-Host "$($service.name) is started. Stopping"
     Stop-ServiceWithTimeout("$($service.name)")
   }
   sleep 5
   cmd /c  sc delete $service.Name
}

$procblock  = {
  Param($proc)
  $pr = Get-Process $proc -ErrorAction SilentlyContinue
  if ($pr) {
    # try gracefully first
    $pr.CloseMainWindow()
    # kill after five seconds
    Sleep 5
    if (!$pr.HasExited) {
		$pr | Stop-Process -Force
    }
  }
}
$initScript = [scriptblock]::Create("Import-Module -Name '.\scripts\sideFunctions.psm1'")
Get-Service -Displayname "*Baltbet*" |  % {Start-Job -InitializationScript $initScript -Scriptblock $serviceblock -ArgumentList $_ }
Get-Job | Wait-Job | Receive-Job
sleep 2 
$procs = @("KernelWeb", "Kernel")
#### grep all baltbet services
Get-Process "*baltbet*"| % {$procs +=$_.ProcessName}

$procs | % {Start-Job -InitializationScript $initScript -Scriptblock $procblock -ArgumentList $_ }
Get-Job | Wait-Job | Receive-Job
Get-Service *Baltbet* | ForEach-object{ 
	if($_.status  -eq "Stopped"){
		cmd /c  sc delete $_.Name
	}
	elseif($_) {
		try{
			$_.WaitForStatus("Stopped")
			cmd /c  sc delete $_.Name
		}catch{
			write-output "$_  is not exist"
		}
	}
	else{
		write-output 'No service installed'}
}
#### cleanup Kernel
Remove-Item -Path C:\Kernel, C:\KernelWeb -Force -Recurse -ErrorAction SilentlyContinue

#### cleanup services folders
Remove-Item -Path C:\Services\* -Force -Recurse -ErrorAction SilentlyContinue

#### cleanup default logs
Remove-Item -Path C:\Logs\* -Force -Recurse -ErrorAction SilentlyContinue

if ($global:LASTEXITCODE -ne 0){
	$global:LASTEXITCODE = 0
}
