def getHostByLabel(Map config= [:]){
  if(config._checkbox){
   return Jenkins
            .instance
            .getNodes()
            .findAll{
              it.getLabelString().contains(config.label)
              }
            .findAll{ it.toComputer().isOnline() }
            .name
  }
  else{ return  false }
}

def defineMvn(List props=[]){
  def _str = props.join('" "-D')
  return "\"-D${_str}\""
}

def getBuilds(Map config = [:]){
  AGENTS = getHostLabel(
    _checkbox: config.INPUTMAP.AllNodes,
    label: config.GROUPID) ?: config.AGENT_LABEL
  BUILDERS = [:]
  AGENTS.each { BuildAgent ->
    BUILDERS[BuildAgent]= {
      node(BuildAgent){
        def deployparams = [
          "deploy.groupId=${config.GROUPID}",
          "deploy.artifactId=${config.INPUTMAP.Branch}",
          "deploy.dir=${config.INPUTMAP.Folder}",
          "deploy.version=${config.INPUTMAP.Version}" ]
        configFileProvider(
            [configFile(
              fileId: 'defaultPom',
              targetLocation: config.POM)]) {
          withMaven(
              globalMavenSettingsConfig: 'GlobalMavenSettings',
              jdk: '11',
              maven: 'latest',
              mavenLocalRepo: '.\\m2-repo',
              mavenSettingsConfig: 'MavenSettings',
              tempBinDir: '.\\m2') {
            bat "mvn clean versions:use-latest-releases dependency:unpack exec:exec -f ${config.POM} -U ${defineMvn(deployparams)}"
          }
        }
        cleanWs notFailBuild: true
      }
    }
  }
  return BUILDERS
}

