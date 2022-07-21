param(
  [string]
  $ItemPath = $ENV:SERVICE_FOLDER
)

Import-Module  -Force WebAdministration
if (Test-Path IIS:\\AppPools\\$($ItemPath)){
  Stop-WebAppPool -Name $($ItemPath) -ErrorAction SilentlyContinue 
    Stop-WebSite -Name $($ItemPath) -ErrorAction SilentlyContinue 
    Remove-Website -Name $($ItemPath)
  Remove-WebAppPool -Name $($ItemPath)
  while(Test-Path IIS:\\AppPools\\$($ItemPath)){ 
    sleep 2
      Remove-WebAppPool -Name $($ItemPath)
  }
}
Get-WmiObject Win32_Service | % {
  if(\$_.pathname -ilike "*$($ItemPath)*"){
    Stop-Service \$_.Name -verbose
  }
}
if (test-path $($ItemPath)){
  remove-item -Path $($ItemPath) -Recurse -Verbose -ErrorAction Continue
}
else {write-Error '$($ItemPath) does not exists'} """)
