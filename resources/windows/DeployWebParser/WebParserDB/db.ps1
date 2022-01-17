import-module '.\scripts\sideFunctions.psm1'

$ServicesFolder = "C:\Services"
$ServiceName = "WebParser"
$PathToTaskScripts = "$($ServicesFolder)\$($ServiceName)\DB Script"
$db = @(
	@{
		DbName = $ServiceName
		BackupFile = "\\server\tcbuild$\Testers\DB\Parser\Parser.bak"
		RelocateFiles = @(
			@{
				SourceName = "ParserNew"
				FileName = "$($ServiceName).mdf"
			}
			@{
				SourceName = "ParserNew_log"
				FileName = "$($ServiceName)_log.ldf"
			}
			@{
				SourceName = "ParserNew_Log2"
				FileName = "$($ServiceName)_LOg2.ldf"
			}
		)
	}
)

Write-Host -ForegroundColor Green "[INFO] Create WebParser database..."
RestoreSqlDb($db)

if (!(Get-ChildItem "$($PathToTaskScripts)\*" -include "*.sql")) {
    write-host "no task for this branch"
    break
}

foreach ($file in (Get-ChildItem "$($PathToTaskScripts)\*" -include "*.sql")){
    Write-Host -ForegroundColor Green "[INFO] Invoke $($file.Name) script..."
    Invoke-Sqlcmd  -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $ServiceName -InputFile $file.FullName -Verbose -ErrorAction continue
}
