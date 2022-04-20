import groovy.json.JsonSlurper

def makeGetReq(requestUrl,basicAuth){
    try {
        def url = new URL(requestUrl)
        def get = url.openConnection()
        get.requestMethod ="GET" 
        get.setRequestProperty("Content-Type", "application/json")
        get.setRequestProperty("Authorization", basicAuth)
        def getRC = get.getResponseCode()
        if (getRC.equals(200)) {
            return get.getInputStream().getText()
        }
    }
    catch(Exception e) {
        println("ERROR: " + e.toString()); 
    }
}

def getBranches(Map config = [:] ){
    def authStr = "Basic " + new String(Base64.getEncoder().encode(config.creds.getBytes()))
    def filterStr = "repository=${config.repo}&maven.groupId=${config.groupid}&maven.extension=zip"
    def result = []
    def url = config.searchUrl + filterStr
    def resp = makeGetReq(url,authStr)
    def jsonSlurper = new JsonSlurper()
    def json = jsonSlurper.parseText(resp)
    result.addAll(json.items*.maven2.artifactId.unique())
    while(json.continuationToken){
        url = config.searchUrl +
            "continuationToken=${json.continuationToken}&" + filterStr
        resp = makeGetReq(url,authStr)
        jsonSlurper = new JsonSlurper()
        json = jsonSlurper.parseText(resp)
        result.addAll(json.items*.maven2.artifactId.unique())
    }
    return result.unique().sort().reverse()
}
