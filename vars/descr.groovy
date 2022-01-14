def setAllowDescr(Map config = [:]){
	def GIT_COMMIT_MSG = powershell (
			script: 'git log -1 --pretty=%B ${GIT_COMMIT}', 
			returnStdout: true, 
			label: "get commit message").trim()
	def GIT_COMMIT = powershell (
			script: 'git log -1 --pretty=%h', 
			label: "get commit message",
			returnStdout: true).trim()
	def BUILD_TRIGGER_BY = config.couse.shortDescription + 
		"/" + config.couse.userId

	return (currentBuild.description ? currentBuild.description +'<br>' : '') +
		"vm: ${TESTVM}<br>${BUILD_TRIGGER_BY}" +
		"<br>CommitMsg: ${GIT_COMMIT_MSG}" +
		"<br>CommitHash: ${GIT_COMMIT}"+
		"<br>Task(Branch): ${params.Task}"
}

def setDenyDescr(lastDescr){
	def lastBuildDescr = "Can't find any info about last successfull build"
	if(lastDescr){
		lastBuildDescr ="Last successfull build " +
			lastDescr[1] +' '+ lastDescr[2] +
			" <br>Last  ${lastDescr[0]}"
	}
	currentBuild.description = "VM ${params.TESTVM} is Locked. " +
		" Skipped <br><p><a href='" + 
		"${JENKINS_URL}lockable-resources/"+
		"'>Remove VM Lock</a><p><br>${lastBuildDescr}"
}
