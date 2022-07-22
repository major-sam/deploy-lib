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
  AGENTS = getHostByLabel(
    _checkbox: config.INPUTMAP.AllNodes,
    label: config.GROUPID) ?: [ config.AGENT_LABEL ]
  BUILDERS = [:]
  AGENTS.each { BuildAgent ->
    BUILDERS[BuildAgent]= {
      node(BuildAgent){

        if (config.INPUTMAP.Cleanup ){
          stage('Cleanup files'){
            catchError(buildResult:null, stageResult: 'UNSTABLE') {
              powershell(
                  label: 'Cleanup files&service',
                  script: """
                  Get-WmiObject Win32_Service | % {
                    if(\$_.pathname -ilike "*${params.Folder}*"){
                      Stop-Service \$_.Name -verbose
                    }
                  }
                  if (test-path ${params.Folder}){
                    remove-item -Path ${params.Folder} -Recurse -Verbose
                  }
                  else {write-Error '${params.Folder} does not exists'}
                  """)
            }
          }
        }
        
        stage('deploy'){
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
        }

        stage('Configure'){
          withFolderProperties {
            catchError(buildResult:null, stageResult: 'UNSTABLE') {
              if ( isUnix() ){
                sh (
                    label:'configure.py',
                    script:"""
                    python -m pip install -r .Deploy/requirements.txt || true
                    python ./Deploy/configure.py
                    """)
              }
              else {
                powershell (
                    label: 'configure.py',
                    script:"""
                    if (test-path ${params.Folder}\\Deploy\\requirements.txt){
                      \\Python310\\python.exe -m pip -r ${params.Folder}\\Deploy\\requirements.txt
                    }
                    \\Python310\\python.exe ${params.Folder}\\Deploy\\configure.py
                    """)
              }
            }
          }
        }
        if (config.INPUTMAP.WinSvc && isUnix()){
          stage('Install Service'){
            catchError(buildResult:null, stageResult: 'UNSTABLE') {
              powershell(
                label: 'Install service (ignore errors)',
                script: "${params.Folder}\\Deploy\\windows\\registerService.ps1")
            }
          }
        }
        cleanWs notFailBuild: true
      }
    }
  }
  return BUILDERS
}

