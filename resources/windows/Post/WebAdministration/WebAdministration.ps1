Import-module '.\scripts\sideFunctions.psm1'

#get release params
###vars
$targetDir = "C:\inetpub\ClientWorkPlace\UniRu"
$webConfig = "$targetDir\Web.config"
$dbname = "WebAdministration"

###
#XML values replace UniRu
####
Write-Host -ForegroundColor Green "[INFO] Edit web.config of $webConfig"
$webdoc = [Xml](Get-Content $webConfig)

$isAdministrationContext = ($webdoc.configuration.connectionStrings.add | Where-Object { $_.name -eq 'AdministrationContext' })
if ($isAdministrationContext) {
	Write-Host -ForegroundColor Green "[INFO] Change AdministrationContext.connectionString"
    $isAdministrationContext.connectionString = "data source=localhost;initial catalog=${dbname};Integrated Security=true;MultipleActiveResultSets=True;"    
}
else {
    Write-Host -ForegroundColor Green "[INFO] There is not AdministrationContext.connectionString in $webConfig"
}

$webdoc.Save($webConfig)
