import groovy.json.JsonSlurperClassic
import groovy.json.JsonOutput
import jenkins.model.Jenkins

def kuberPortShift(Map config = [:]){          
	return config.port + config.VM.replaceAll("\\D+","").toInteger()
}

def getKuberNodeLabel(Map config = [:]){
	def nodes =nodesByLabel config.nodeLabel
	nodes=nodes.sort()
	return nodes[config.KuberID]
}

def getKuberNodeIP(Map config = [:]){
	def nodes =nodesByLabel config.nodeLabel
	nodes=nodes.sort()
	return Jenkins.getInstance().getComputer(nodes[config.KuberID]).getHostName()
}

//def getKuberNodeLabel(Map config = [:]){
//	def nodes =nodesByLabel config.nodeLabel
//	nodes=nodes.sort()
//	if (config.VM.replaceAll("\\D+","").toInteger() % 2 == 0){
//		return nodes[1]
//	}
//	else{
//		return nodes[0]
//	}
//}
//
//def getKuberNodeIP(Map config = [:]){
//	def nodes =nodesByLabel config.nodeLabel
//	nodes=nodes.sort()
//	if (config.VM.replaceAll("\\D+","").toInteger() % 2 == 0){
//		return Jenkins.getInstance().getComputer(nodes[1]).getHostName()
//	}
//	else{
//		return Jenkins.getInstance().getComputer(nodes[0]).getHostName()
//	}
//}

def getLastSuccessfullTaskJobDescription(node){
	def test_job = Jenkins.instance.getItemByFullName(JOB_NAME)
	prev_sucessful_build=test_job.getLastSuccessfulBuild()
	while (prev_sucessful_build){
		prev_sucessful_build_descr=prev_sucessful_build.getDescription()
		if(prev_sucessful_build_descr){
			if (prev_sucessful_build_descr.contains("${node}")){
				def matches = (prev_sucessful_build_descr =~ /Task\(Branch\):.*$/) 
				return [
					matches[0], 
					prev_sucessful_build.getId(), 
					prev_sucessful_build.getCauses()[0].shortDescription as String
				]
			}
			else{
				prev_sucessful_build = prev_sucessful_build.getPreviousSuccessfulBuild()
					prev_sucessful_build_descr = false
			}
		}
		else{
			prev_sucessful_build = prev_sucessful_build.getPreviousSuccessfulBuild()
				prev_sucessful_build_descr = false
		}
	}
}

def	addToDescription(Map config = [:]){
	def String result = ""
	if (config.position instanceof Integer){
		def splitedDescr = config.description.split('<br>') as List
		splitedDescr.add(config.position, config.html)
		result = splitedDescr.join('<br>')
	}
	else{
		result = "$config.description <br> $config.html"
	}
	return result
}


def lookupBranchInNexus (repoName, task){
	withCredentials([file(credentialsId: 'NexusNetRC', variable: 'NexusNetRC')]){
		def text = powershell (
				returnStdout: true,
				label: 'Lookup branch ' + task + ' in repo ' + repoName ,
				script : '''
				curl.exe --netrc-file "$env:NexusNetRC" `
					-X GET "http://nexus:8081/service/rest/v1/search/assets?repository=''' +
					repoName +'&maven.groupId='+repoName+
					'&maven.artifactId=' +task +
					'''&maven.extension=zip" `
					-H "accept: application/json" 4>&1 2>$null
				'''
				)
		def repoMap = new JsonSlurperClassic().parseText(text)
		def boolean foundIt = repoMap.items.size() > 0
		return foundIt
	}
}

def getNexusBranch (repoName, userTask){
	if (userTask =~ /^[A-Z]{2,}-\d+$/){
		if (lookupBranchInNexus(repoName , userTask)) { return userTask }
        if (lookupBranchInNexus(repoName , "feature-${userTask}")) {
			return  "feature-${userTask}" 
			}
	}
	def NotFeatureTask =  defaultNexusNaming(userTask) 
	def hasMaster = lookupBranchInNexus(repoName, 'master')
	if(NotFeatureTask && (lookupBranchInNexus(repoName, NotFeatureTask)) ){
		return NotFeatureTask
	}
	else{
		return  (hasMaster) ? 'master' : false
	}
}


def updatePom(services, branchTask){
	services.each{ 
		nexusLookup = getNexusBranch(it, branchTask)
		if (nexusLookup == 'master'){
			return
		}
		else if (nexusLookup){
			powershell (
				script: '''
				\$pom= "'''+ "${env.WORKSPACE}\\deployPom.xml" +'''"
				\$xml= [Xml] (Get-Content \$pom)
				((\$xml.project.build.plugins.plugin  |? {
					\$_.artifactId -like 'maven-dependency-plugin' }).configuration.artifactItems.artifactItem| ? {
						\$_.groupId -like "'''+ it +'''"}).artifactId = "'''+ nexusLookup  +'''"
				\$xml.Save(\$pom)
				''',
				label: 'Update pom '+ it + ' with ' + nexusLookup, 
				returnStdout:true
				)
		} 
		else{
			error ("${it} has no master in nexus!")
		}
	}	
}

def getPomServices(){
	def services = powershell(
		returnStdout: true,
		script:'''
			\$pom= "'''+ "${env.WORKSPACE}\\deployPom.xml" +'''"
			\$xml= [Xml] (Get-Content \$pom)
			\$artifacts=(\$xml.project.build.plugins.plugin  |? {
					 \$_.artifactId -like 'maven-dependency-plugin' }).configuration.artifactItems.artifactItem| % {
									 \$_.groupId} 
			 Write-Output ($artifacts -join ",")''',
		 encoding: 'UTF8').split(',') as List
	services[-1] = services[-1].replaceAll("[^A-Za-z0-9]", "")
	return services.sort()
}

def doMavenDeploy(taskBranch){
	def resultList = []
	services = getPomServices()
	updatePom(services,taskBranch)
	def deployParams = "\"-Dmaven.repo.local=${env.WORKSPACE}\\.mvn\\\" "
	configFileProvider(
			[
			configFile(
				fileId: 'mavenSettingsGlobal', 
				targetLocation: 'MAVEN_SETTINGS.xml')
			]){
		powershell "mvn clean versions:use-latest-releases dependency:unpack -s MAVEN_SETTINGS.xml -f deployPom.xml ${deployParams}"
	}
	result = powershell(
			script:"""
				\$svc = "${services.join(',')}".Split(',')
				Get-ChildItem -Directory .\\.mvn | % {
					if (\$_ -iin \$svc){
						\$branch =  Get-ChildItem -Directory \$_.FullName
						\$ver = Get-ChildItem -Directory \$branch.FullName
						write-output "=========`n\$_ :`n`t\$branch - \$ver"
					}
				}
			""", 
			label: 'get bundle',
			returnStdout: true)
	return """$result"""
}

def doSingleServiceMavenDeploy(Map config = [:]){
	def taskBranch = getNexusBranch (config.groupId, config.branch)
	if (taskBranch){
		def deployParams = (
				"\"-Dmaven.repo.local=" + config.repo + "\" " +
				"\"-Ddeploy.groupid=" + config.groupId+ "\" " +
				"\"-Ddeploy.dir=" + config.deployDir +  "\" " +
				"\"-Ddeploy.branch=" + taskBranch +  "\""
				)
		powershell (
				script: "mvn clean versions:use-latest-releases" +
				" dependency:unpack -s MAVEN_SETTINGS.xml"+
				" -f pomxml ${deployParams}",
				label: "Maven deploy ${config.groupId} branch ${taskBranch}"
				)
		def packageVersion = powershell (
				script:"(Get-ChildItem -Directory "+ 
				config.repo +"\\"+config.groupId+"\\"+
				taskBranch+" | Select-Object -First 1).name", 
				returnStdout: true
				)
		return """
		============
			Repo: ${config.groupId},
			Branch: $taskBranch,
			Version: ${packageVersion.trim()}
		"""
	}
	else{
		error ("${config.groupId} repo has no master branch")

	}
}
