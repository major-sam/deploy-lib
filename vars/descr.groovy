def setAllowDescr(Map config = [:]){
	def BUILD_TRIGGER_BY = config.couse.shortDescription + 
		"/" + config.couse.userId

	return (currentBuild.description ? currentBuild.description +'<br/>' : '') +
		"vm: ${config.vmName}<br/>${BUILD_TRIGGER_BY}" +
		"<br/>Task(Branch): ${params.Task ? params.Task : config.task}"
}

def setDenyDescr(Map config = [:]){
	def lastBuildDescr = "Can't find any info about last successfull build"
	if(lastDescr){
		lastBuildDescr ="Last successfull build " +
			config.descr[1] +' '+ congfig.descr[2] +
			" <br/>Last  ${config.descr[0]}"
	}
	currentBuild.description = "VM ${config.vmName} is Locked. " +
		" Skipped <br/><p><a href='" +
		"${JENKINS_URL}lockable-resources/"+
		"'>Remove VM Lock</a><p><br/>${lastBuildDescr}"
}
