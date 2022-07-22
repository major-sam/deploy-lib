import jenkins.model.Jenkins
import groovy.xml.*

def findLocks(Map config = [:]){
	def resManager = org.jenkins.plugins
		.lockableresources
		.LockableResourcesManager
		.get()
	resManager.createResourceWithLabel(config.resource ,"${env.prod?.trim()?'PROD_LOCK':'DEFAULTLOCK' }")
	def all_lockable_resources = resManager.resources
	def lockable_resource = all_lockable_resources.find { r->
		r.getName() == config.resource
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

def setNotes(Map config = [:]){
	def dateTime = String.format('%tF %<tH:%<tM', java.time.LocalDateTime.now())
	def services ='Default'
	comments = config.comments ? config.comments : '---'
	services += (config.tt == 'true') ? ' + TT' : ''
	services += (config.widgets == 'true') ? ' + Baltbet Widgets' : ''
	services += (config.webParser == 'true') ? ' + Web Parser' : ''
	services += (config.ms == 'true') ? ' + Marketing Service' : ''
	services += (config.pay == 'true') ? ' + Payment Service' : ''

	if ((!config.branch?.trim()) || config.branch.toLowerCase().contains('master')){
		branch = "<strong>Branch: </strong>master</p>"
	}
	else{
		branch = "<strong>Branch: </strong>${config.branch}</p>"
	}
	def buildUrl = "<strong>Build Number: <a title='Build Url' href='${config.buildUrl}' target='_blank'>#${config.buildNumber}</a></strong></p>"
	def lockNotes = "<p style=text-align: center;'><strong>Services: </strong><span style='text-decoration: underline;'>${services}</span>&nbsp; &nbsp; &nbsp;" + 
		branch + "<p style=text-align: center;'><strong>Comments: </strong>${comments}&nbsp; &nbsp; &nbsp;" + 
		buildUrl +
		"<p style='text-align: center;'><strong>Build Status: </strong>${config.buildStatus}</p>" +
		"<p style='text-align: center;'><strong>${dateTime}</strong></p><hr />"
	def rManager = org.jenkins.plugins.lockableresources.LockableResourcesManager
	def MyRManager = rManager.get()
	def myResources = MyRManager.getResources() 
	def resource = myResources.find{ it.getName().equalsIgnoreCase(config.vmName)}
	if (resource.getLabels().contains('DEVOPSLOCK')){
		println 'DEVOPS VM'
		println resource.getLabels()
	}
	else{
		resource.setNote(lockNotes)
	}
}

def addNotes(Map config = [:]){
	def dateTime = String.format('%tF %<tH:%<tM', java.time.LocalDateTime.now())
	def resource = org.jenkins.plugins.lockableresources.LockableResourcesManager
		.get()
		.getResources()
		.find{ it.getName().equalsIgnoreCase(config.vmName)}
	def currentNotes = resource.getNote().split('\n') as List
	println currentNotes
	currentNotes.removeAll{ it.contains("id=${config.id}")}
	println currentNotes
	def lockNotes = (currentNotes + "<p style='text-align: center;'>${config.notes} <strong>$dateTime</strong></p>").join('\n')
	resource.setNote(lockNotes)
}
