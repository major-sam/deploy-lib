import groovy.json.*
import groovy.xml.*
import groovy.json.JsonOutput
import jenkins.model.Jenkins
import java.util.stream.*

def kuberPortShift(Map config = [:]){
	return config.port + config.VM.replaceAll("\\D+","").toInteger()
}

def getKuberNodeLabelv2(Map config = [:]){
	def nodes =nodesByLabel config.nodeLabel
	nodes=nodes.sort()
	return nodes[config.KuberID]
}

def getNodeIP(Map config = [:]){
	def nodes =nodesByLabel config.nodeLabel
	return Jenkins.getInstance().getComputer(nodes[0]).getHostName()
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

def getNodeList(label = 'windows'){
	return Jenkins
		.instance
		.getNodes()
		.findAll{ it.getLabelString().contains(label) }
		.findAll{ it.toComputer().isOnline() }
		.name as List
}

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
		def splitedDescr = config.description.split('<br/>') as List
		splitedDescr.add(config.position, config.html)
		result = splitedDescr.join('<br/>')
	}
	else{
		result = "$config.description <br/> $config.html"
	}
	return result
}


def lookupBranchInNexus (repoName, task){
	def nexusUrl = "https://nexus.gkbaltbet.local/service/rest/v1/search/assets?repository="+
					repoName +'&maven.groupId='+repoName+
					'&maven.artifactId=' +task +
					'&maven.extension=zip'
	def response = httpRequest (
							authentication: 'jenkinsAD',
							ignoreSslErrors: true,
							validResponseCodes: '200,404,500',
							quiet: true,
							url: nexusUrl)
	if (response.status == '500'){
		response = httpRequest (
							authentication: 'jenkinsAD',
							ignoreSslErrors: true,
							validResponseCodes: '200,404',
							url: nexusUrl)
	}
	def json = new JsonSlurper().parseText(response.getContent())
	return (json.items.size() > 0)
}

def getNexusGroupID(repoName, userTask){
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

@NonCPS
def replaceArtifactId(pom, service, nexusGroupId){
	pom.build
		.plugins
		.plugin
		.find{it.artifactId.text() == 'maven-dependency-plugin'}
	.configuration
		.artifactItems
		.artifactItem
		.find{it.groupId.text() == service}
	.artifactId[0].setValue(nexusGroupId)
}

def getArtifacts(){
	def xmlfile =readFile('deployPom.xml')
	def pom = new XmlParser(false,false).parseText(xmlfile)
	Map result =  pom
		.build
		.plugins
		.plugin
		.find{it.artifactId.text() == 'maven-dependency-plugin'}
		.configuration
		.artifactItems
		.artifactItem
		.collectEntries{[it.groupId.text(), it.outputDirectory.text()]}
	println JsonOutput.prettyPrint(JsonOutput.toJson(result))
	return result
}

def doMavenDeploy(taskBranch){
	def resultList = []
	def xmlfile =readFile('deployPom.xml')
	pom = new XmlParser(false,false).parseText(xmlfile)
	services = pom.build
		.plugins
		.plugin
		.find{it.artifactId.text() == 'maven-dependency-plugin'}
		.configuration
		.artifactItems
		.artifactItem
		.collect{it.groupId.text()}.sort()
	services.each{service ->
		def String nexusGroupId =  getNexusGroupID(service,taskBranch)
		if (nexusGroupId == 'master'){
			println "${service} GroupId: master"
		}
		else if (nexusGroupId){
			println "${service} GroupId: ${nexusGroupId}"
				replaceArtifactId(pom, service, nexusGroupId)
		}else{ error("$service has no master")}
}
	writeFile encoding: 'UTF8', file:'deployPom.xml', text: groovy.xml.XmlUtil.serialize(pom)
	withMaven(
		globalMavenSettingsConfig: 'mavenSettingsGlobal',
		jdk: '11',
		maven: 'maven382',
		mavenLocalRepo: ".mvn",
		mavenSettingsConfig: 'mavenSettings') {
		bat "mvn clean versions:use-latest-releases dependency:unpack -f deployPom.xml -U "
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
	def taskBranch = getNexusGroupID (config.groupId, config.branch)
	if (taskBranch){
		def deployParams = [
				"-Ddeploy.groupid=${config.groupId}",
				"-Ddeploy.dir=${config.deployDir}",
				"-Ddeploy.branch=${taskBranch}",
				"-DartifactName=${config.groupId}"].join(' ')
		withMaven(
				globalMavenSettingsConfig: 'mavenSettingsGlobal',
				jdk: '11',
				maven: 'maven382',
				mavenLocalRepo: ".mvn",
				mavenSettingsConfig: 'mavenSettings') {
			bat "mvn clean versions:use-latest-releases dependency:unpack -f ${config.pom} -U ${deployParams}"
		}
		def packageVersion = powershell (
				script:"(Get-ChildItem -Directory .mvn"+
				"\\"+config.groupId+"\\"+
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
