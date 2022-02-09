import-module '.\scripts\sideFunctions.psm1'

$ServicesFolder = "C:\Services"
$ServiceName = "WebParser"
$PathToTaskScripts = "$($ServicesFolder)\$($ServiceName)\DB Script"
$db = @(
	@{
		DbName = "Parser"
		BackupFile = "\\server\tcbuild$\Testers\DB\Parser\Parser.bak"
		RelocateFiles = @(
			@{
				SourceName = "ParserNew"
				FileName = "Parser.mdf"
			}
			@{
				SourceName = "ParserNew_log"
				FileName = "Parserlog.ldf"
			}
			@{
				SourceName = "ParserNew_Log2"
				FileName = "Parser_LOg2.ldf"
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
    Invoke-Sqlcmd  -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database "Parser" -InputFile $file.FullName -Verbose -ErrorAction continue
}
