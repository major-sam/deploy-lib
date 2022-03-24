import-module '.\scripts\sideFunctions.psm1'

$ServicesFolder = "C:\Services"
$ServiceName = "WebParser"
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

