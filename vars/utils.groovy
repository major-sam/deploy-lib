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

def getVmList(int max){
	def ints = 10..max
	def VM_LIST = [
		"devops-test-vm1",
		"devops-test-vm2", 
		"devops-test-vm3",
		"devops-test-vm4",
		"devops-test-vm5",
		"devops-test-vm6",
		"devops-test-vm7",
		"devops-test-vm8",
		"devops-test-vm9"
	]
	for (id in ints){
		VM_LIST += "devops-testvm${id}"
	}
	return VM_LIST
}

def lookupBranchInNexus (repoName, task){
	withCredentials([file(credentialsId: 'NexusNetRC', variable: 'NexusNetRC')]){
		def text = powershell (
				returnStdout: true,
				script : '''
				curl.exe --netrc-file "$env:NexusNetRC" `
					-X GET "http://nexus:8081/service/rest/v1/search/assets?repository=''' +repoName+
					'''&maven.groupId='''+repoName+
					'''&maven.artifactId='''+task+'''&maven.extension=zip" `
					-H "accept: application/json" 4>&1 2>out-null
				'''
				)
		def repoMap = new JsonSlurperClassic().parseText(text)
		return (repoMap.items.size() > 0)
	}
}

def getNexusBranch (repoName, userTask){
	if (userTask =~ /^[A-Z]{2,}-\d+$/){
		if (lookupBranchInNexus(repoName , userTask)) { return userTask }
        if (lookupBranchInNexus(repoName , "feature-${userTask}")) { return  "feature-${userTask}" }
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
		if (nexusLookup && nexusLookup != 'master'){
			println 'Update pom '+ it + ' with ' + nexusLookup 
			powershell (
				script: '''
				\$pom= "'''+ "${env.WORKSPACE}\\deployPom.xml" +'''"
				\$xml= [Xml] (Get-Content \$pom)
				((\$xml.project.build.plugins.plugin  |? {
					\$_.artifactId -like 'maven-dependency-plugin' }).configuration.artifactItems.artifactItem| ? {
						\$_.groupId -like "'''+ it +'''"}).artifactId = "'''+ nexusLookup  +'''"
				\$xml.Save(\$pom)
				''',
				returnStdout:true
				)
				
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
	println services
	return services
}

def doMavenDeploy(taskBranch){
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
	services.each { service -> 
		def packageBranch = powershell (
			script:"(Get-ChildItem -Directory .\\.mvn\\${service}| Select-Object -First 1).name", 
			returnStdout: true)
		def packageVersion = powershell (
			script:"(Get-ChildItem -Directory (Get-ChildItem -Directory .\\.mvn\\${service}| Select-Object -First 1).FullName).name", 
			returnStdout: true)
		MavenDeployResultList << [
			Repo: service,
			Branch: packageBranch.trim(),
			Version: packageVersion.trim()
		]
	}
}


def getParralelDeliveryMap(src){
	return src.collectEntries{[ (it['name']) : deliverSources(it)
	]}
}

def deliverSources(src){
	return{
		stage(src['name']){ 
			powershell (
					encoding:'UTF8', 
					script:"${src['source']}"
					)
		}
	}
}

