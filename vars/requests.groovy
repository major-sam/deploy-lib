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

def updateConfluence(Map config = [:] ){
    def url = "https://confluence.baltbet.ru:8444/rest/api/content/${config.root}/child/page"
    def rootChilds = httpRequest (
        consoleLogResponseBody: true,
        authentication: config.auth,
        responseHandle: 'NONE',
        url: url,
        wrapAsMultipart: false)
    def text = rootChilds.getContent()
    def json = readJSON text: text
    if (vm in json.results*.title){
        id = json.results.find{it.title == vm}.id
        int version = (json.results.find{it.title == vm}.version) ? json.results.find{it.title == vm}.version as Integer : 1 
        httpRequest (
                authentication: config.auth,
                consoleLogResponseBody: false,
                contentType: 'APPLICATION_JSON',
                httpMode: 'PUT',
                requestBody: """{"id":"${id}","type":"page",
                "title":"${config.vm}","space":{"key":"${config.spacekey}"},"body":{"storage":{"value":
                "${config.body}","representation":"storage"}},"version":{"number":${version + 1}}}""",
                responseHandle: 'NONE',
                url: "https://confluence.baltbet.ru:8444/rest/api/content/${id}",
                wrapAsMultipart: false)
    }else{
        def req = httpRequest (
                authentication: config.auth,
                consoleLogResponseBody: true,
                contentType: 'APPLICATION_JSON',
                httpMode: 'POST',
                requestBody: """
                {"type":"page",""title":${config.vm}",
                "ancestors":[{"id":${config.root}}], "space":{"key":"${config.spacekey}"},"body":{"storage":{"value":
                "${config.body}","representation":"storage"}}}""",
                responseHandle: 'NONE',
                url: "https://confluence.baltbet.ru:8444/rest/api/content/",
                wrapAsMultipart: false)
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
    if (config.regexFilter){
        return result.unique().sort().reverse().findAll {it ==~ config.regexFilter} }
    else{
        return result.unique().sort().reverse()}
}
