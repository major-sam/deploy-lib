def call(Map config = [:]) {
   withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: config.creds, usernameVariable: 'username', passwordVariable: 'password']]) {
     powershell ( encoding: 'UTF8', script:"""
       \$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "$username","$password")))
       \$requestHeaders = @{
         "content-length" = 0
         "Authorization" = ('Basic {0}' -f \$base64AuthInfo)
       }
       \$endpointUri = '$config.BRANCH_LIST_URL'
       \$json = Invoke-RestMethod -Method get -Uri \$endpointUri -Headers \$requestHeaders -ContentType "application/json"
       \$json.values.displayId | Sort-Object | set-content -Encoding "utf8" branch.txt
     """)
     env.DEFAULT_BRANCH = powershell ( encoding: 'UTF8', returnStdout: 'true', script:"""
       \$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "$username","$password")))
       \$requestHeaders = @{
         "content-length" = 0
         "Authorization" = ('Basic {0}' -f \$base64AuthInfo)
       }
       \$endpointUri = '$config.BRANCH_LIST_URL'
       \$json = Invoke-RestMethod -Method get -Uri \$endpointUri -Headers \$requestHeaders -ContentType "application/json"
       \$default = \$json.values | where { \$_.isDefault -eq "true" } 
       \$default.displayId.trim()
     """)
    }
}
