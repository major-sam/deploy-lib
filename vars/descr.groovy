def setAllowDescr(Map config = [:]){
	def BUILD_TRIGGER_BY = config.couse.shortDescription + 
		"/" + config.couse.userId

	return (currentBuild.description ? currentBuild.description +'<br/>' : '') +
		"vm: ${config.vmName}<br/>${BUILD_TRIGGER_BY}" +
		"<br/>Task(Branch): ${params.Task ? params.Task : config.task}"
}

def setDenyDescr(Map config = [:]){
	currentBuild.description = "VM ${config.vmName} is Locked. " +
		"<a href='${JENKINS_URL}lockable-resources/'>Remove VM Lock</a>"
}
