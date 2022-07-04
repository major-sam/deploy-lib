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
    def url = "https://confluence.baltbet.ru:8444/rest/api/content/${config.root}/child/page?limit=100"
    def rootChilds = httpRequest (
        consoleLogResponseBody: true,
        authentication: config.auth,
        responseHandle: 'NONE',
        url: url,
        wrapAsMultipart: false)
    def text = rootChilds.getContent()
    def json = readJSON text: text
    if (config.vm in json.results*.title){
        id = json.results.find{it.title == config.vm}.id
        def versionReq =  httpRequest (
                consoleLogResponseBody: true,
                authentication: config.auth,
                responseHandle: 'NONE',
                url:"https://confluence.baltbet.ru:8444/rest/api/content/${id}?expand=body.storage,version",
                wrapAsMultipart: false)
        def versionMap = readJSON text:versionReq.getContent()
        int version = versionMap.version.number as Integer
        def reqBody = """{"id":"${id}","type":"page",
                "title":"${config.vm}","space":{"key":"${config.spacekey}"},"body":{"storage":{"value":
                "${config.body}","representation":"storage"}},"version":{"number":${version + 1}}}"""
        println reqBody
        httpRequest (
                authentication: config.auth,
                consoleLogResponseBody: true,
                contentType: 'APPLICATION_JSON_UTF8',
                httpMode: 'PUT',
                requestBody:reqBody,
                responseHandle: 'NONE',
                url: "https://confluence.baltbet.ru:8444/rest/api/content/${id}",
                wrapAsMultipart: false)
    }else{
        def reqBody =  """
        {"type":"page","title":"${config.vm}",
        "ancestors":[{"id":${config.root}}], "space":{"key":"${config.spacekey}"},"body":{"storage":{"value":
        "${config.body.trim().replaceAll("[\r\n]+","<br/>")}","representation":"storage"}}}"""
        println reqBody
        def req = httpRequest (
                authentication: config.auth,
                consoleLogResponseBody: true,
                contentType: 'APPLICATION_JSON_UTF8',
                httpMode: 'POST',
                requestBody:reqBody,
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
