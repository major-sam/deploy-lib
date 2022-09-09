<#
В админке юни сайта включить клиентский рендеринг для лайва и линии: Настройки -> Страницы -> События -> поставить две галки
#>

$dbname = "UniAdministration"
$query = "
USE UniAdministration

INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (2, 'Pages.Events.IsPrematchClientSideRenderingEnabled', 'true', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (2, 'Pages.Events.IsLiveClientSideRenderingEnabled', 'true', 0)
GO
"

Write-Host "[INFO] Enable 'Pages.Events.*' client rendering"
Invoke-Sqlcmd -QueryTimeout 360 -verbose -ServerInstance $env:COMPUTERNAME -Database $dbname -query $query -ErrorAction stop