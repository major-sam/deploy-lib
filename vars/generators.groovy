
def getParralelStagesMap(Map config = [:]){
	def result = config.jsonMap.collectEntries {[
		(it.name) : {
			stage(it.name){
				generateStages(
					job:it,
					stageName: config.stage,
					envOS: (isUnix() ? "linux" : "windows"))
			}
		}]
	}
	return result
}

def generateStages(Map config = [:] ) {
	Closure stagesResults = {}
	if (config.job.stages){
		for (stageScript in config.job.stages){
			def libScriptPath = [
				config.envOS,
				config.stageName,
				config.job.name,
				stageScript ].join('/')
			def libScript = libraryResource libScriptPath 
			stagesResults << getSubStage(
				scriptCase:stageScript.split('\\.')[-1],
				stageName: stageScript.split('\\.')[0],
				script: libScript,
				scriptPath:libScriptPath)
		}
	}
	if (config.job.inCodeStages){
		for ( inCodeStageScript in config.job.inCodeStages){
			def libScriptPath = [
				config.artifactItems[config.job.name],
				'Deploy',
				config.envOS,
				inCodeStageScript 
			].join('/')
			println "${config.job.name} will be use in code deploy scripts from ${config.artifactItems[$config.job.name]}/Deploy"
			libScript = readFile (libScriptPath)
			stagesResults << getSubStage(
				scriptCase:inCodeStageScript.split('\\.')[-1],
				stageName: inCodeStageScript.split('\\.')[0],
				script: libScript,
				scriptPath:libScriptPath)
		}
	return stagesResults
	}
}

def getSubStage(Map config = [:]){
	switch(config.scriptCase){
		case 'ps1':
			return stage(config.stageName){
				powershell (
						encoding: 'UTF8',
						script: config.script,
						label: config.scriptPath)
			}
		case 'sql':
			def PsScript = """ Invoke-Sqlcmd -Query {$config.script} `
				-verbose `
				-QueryTimeout 0 `
				-ServerInstance localhost `
				-ErrorAction stop"""
				return stage(config.stageName){
					println "SQL SCRIPTS RUNS ON MASTER! \n For other db USE statment requered"
						powershell (
								encoding: 'UTF8',
								script: PsScript,
								label: "Runs on master: ${config.scriptPath}")
				}
		case 'sh':
			return stage(config.stageName){
				sh (
						encoding: 'UTF8',
						script: config.script,
						label: config.scriptPath)
			}
		default:
			return stage("${config.stageName}"){
				println "not suported script extention:" + config.scriptCase
			}
	}
}
