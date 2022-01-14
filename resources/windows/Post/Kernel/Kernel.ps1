import-module '.\scripts\sideFunctions.psm1'

if (test-path "c:\kernel\TasksDB"){
	write-host "[INFO] Exec tasks"
	get-ChildItem "c:\Kernel\TasksDB\*" -include "*.sql" | % {
		Write-Host -ForegroundColor Green "[INFO] Execute script $_ on database BaltBetM"
		Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database 'BaltBetM' -InputFile $_ -ErrorAction continue
		Write-Host -ForegroundColor Green "[INFO] Execute script $_ on database BaltBetMMirror"
		Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database 'BaltBetMMirror' -InputFile $_ -ErrorAction continue
		}
}else{
	write-host "no task for this branch"
}

$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$Config = 'C:\Kernel\settings.xml'
$webdoc = [Xml](Get-Content $Config)

$tmp = ($webdoc.Settings.SiteIPs).FirstChild.CloneNode(1)
$tmp.'#text'=$CurrentIpAddr
$tmp.WorkerId='57'
$tmp.ClientId = '777'
$webdoc.Settings.SiteIPs.AppendChild($tmp)

$tmp = ($webdoc.Settings.SiteIPs).FirstChild.CloneNode(1)
$tmp.'#text'=$CurrentIpAddr
$tmp.ClientId = '7773'
$webdoc.Settings.SiteIPs.AppendChild($tmp)

$webdoc.Save($Config)

$serviceBin = Get-Item  "C:\Kernel\Kernel.exe"
$sname = RegisterWinService($serviceBin)
start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
$serviceBin = Get-Item  "C:\KernelWeb\KernelWeb.exe"
$sname = RegisterWinService($serviceBin)
start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
 return 0
