$log_config = "c:\kernel\config\Log.config"

$xml = [xml](Get-Content -Path $log_config -Encoding utf8)

$foundNode = $xml.log4net.root

$email_appender = [xml]@"
<!-- TEST_ENV_ONLY - Appender for FakeEMailServiceAppender -->
<appender name="FakeEMailServiceAppender" type="log4net.Appender.RollingFileAppender">
<encoding value="utf-8"/>
<file value="c:\logs\kernel\EMailLog"/>
<appendToFile value="true"/>
<rollingStyle value="Composite"/>
<maximumFileSize value="100MB"/>
<datePattern value="yyyy.MM.dd&quot;.log&quot;"/>
<staticLogFileName value="false"/>
<layout type="log4net.Layout.PatternLayout">
    <conversionPattern value="%date [%thread] %-5level - %message%newline"/>
</layout>
</appender>
"@

$sms_appender = [xml]@"
<!-- TEST_ENV_ONLY - Appender for StubSMSServiceAppender -->
<appender name="StubSMSServiceAppender" type="log4net.Appender.RollingFileAppender">
<encoding value="utf-8"/>
<file value="c:\logs\kernel\SMSLog"/>
<appendToFile value="true"/>
<rollingStyle value="Composite"/>
<maximumFileSize value="100MB"/>
<datePattern value="yyyy.MM.dd&quot;.log&quot;"/>
<staticLogFileName value="false"/>
<layout type="log4net.Layout.PatternLayout">
    <conversionPattern value="%date [%thread] %-5level - %message%newline"/>
</layout>
</appender>
"@

$email_logger = [xml]@"
<!-- TEST_ENV_ONLY - Logger for FakeEMailServiceAppender -->
<logger name="FakeEMailService" additivity="false">
<appender-ref ref="FakeEMailServiceAppender"/>
</logger>
"@

$sms_logger = [xml]@"
<!-- TEST_ENV_ONLY - Logger for StubSMSServiceAppender -->
<logger name="StubSMSService" additivity="false">
<appender-ref ref="StubSMSServiceAppender"/>
</logger>
"@

$email_appender = $xml.ImportNode($email_appender.appender,$true)
$xml.log4net.InsertAfter($email_appender, $foundNode) | out-null
$sms_appender = $xml.ImportNode($sms_appender.appender,$true)
$xml.log4net.InsertAfter($sms_appender, $foundNode) | out-null

$email_logger = $xml.ImportNode($email_logger.logger,$true)
$xml.log4net.InsertAfter($email_logger, $foundNode) | out-null
$sms_logger = $xml.ImportNode($sms_logger.logger,$true)
$xml.log4net.InsertAfter($sms_logger, $foundNode) | out-null

$xml.Save("c:\kernel\config\Log.config")
