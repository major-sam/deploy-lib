$svcs = (invoke-sqlcmd -Query "sp_linkedservers").SRV_NAME
if($svcs.contains($env:KERNEL_MIRROR_SERVER)){ 
    $svcs
    Write-Host "$($env:KERNEL_MIRROR_SERVER) allready linked"
}
else{
    invoke-sqlcmd -Query "sp_addlinkedserver  [$($env:KERNEL_MIRROR_SERVER)]" | Out-Null
}
