import jenkins.model.Jenkins

def findLocks(all_lockable_resources){
	def lockable_resource = all_lockable_resources.find { r->
		r.getName() == params.TESTVM
	}
	def boolean locked_by_me = (
		"${lockable_resource.getReservedBy()}" ==
		"${currentBuild.getBuildCauses()[0].userName}"
		)
	if (locked_by_me){
		println "Vm ${lockable_resource}" +
			" is locked by current build user (" +
			currentBuild.getBuildCauses()[0].userName +
			") \n Continue Build"
	}
	return [
		accessDeny:(lockable_resource.isReserved() && !locked_by_me), 
		resource: lockable_resource
		] 
}

