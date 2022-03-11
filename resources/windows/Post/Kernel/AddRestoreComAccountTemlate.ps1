# Добавляем email шаблон в [BaltBetM].[Emails].[EmailTemplates] для RestoreComAccount
$restoreComAccountTemplate = Get-Content -Path ".\RestoreComAccountTemplate.html" -Encoding utf8

$query = "
UPDATE [BaltBetM].[Emails].[EmailTemplates] SET Body = '$restoreComAccountTemplate'
	    WHERE Name = 'RestoreComAccount'
"
Write-Host "[INFO] Add email template for RestoreComAccount"
Invoke-Sqlcmd -Verbose -ServerInstance $env:COMPUTERNAME -Query $query -ErrorAction continue