UPDATE [#DB_NAME].Settings.Options SET Value = CASE Name
WHEN 'Global.WcfClient.WcfServicesHostAddress' THEN '#VM_IP'
ELSE Value END