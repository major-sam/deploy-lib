deploy-lib
https://www.jenkins.io/doc/book/pipeline/shared-libraries/
Extending with Shared Libraries
Jenkins – an open source automation server which enables developers around the world to reliably build, test, and deploy their software

@Library('my-shared-library') _
/* Using a version specifier, such as branch, tag, etc */
@Library('my-shared-library@1.0') _
/* Accessing multiple libraries with one statement */
@Library(['my-shared-library', 'otherlib@abc1234']) _

https://bitbucket.baltbet.ru:8445/projects/DVO/repos/deploy/diff/deploy.json?until=b92f6c87a7468e11ddd821a005630a582f11f794


в библиотеке скрипт для выполнения находится так:
 OS(агента)/StageName(или указать строку)/Параметр Name в json/параметр Stage в файлике(лист - выполняется последовательно) 
