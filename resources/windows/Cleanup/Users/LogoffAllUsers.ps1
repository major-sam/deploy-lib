$quser = quser.exe 2> $null
if ($null -eq $quser) {
    Write-Host -Color Yellow "[WARN] No logged in user found"
    break
}

for ($i = 1; $i -lt $quser.Length; $i++) {
    $currentRow = $quser[$i] -split " {2,17}"
    $sessionid   = [int]$currentRow[2].trim()
    $username = $currentRow[0].trim() -replace ">",""
    Write-Host "[INFO] logging off user $($username)"
    logoff.exe $sessionid /V
}