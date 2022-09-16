echo '==============================='
echo 'rabbitmq helm chart deploy script'
echo '==============================='
echo $NAMESPACE
echo $RABBIT_PORT
echo $RABBIT_WEB_PORT
echo '==============================='

/usr/sbin/helm upgrade -i rabbitmq bitnami/rabbitmq  \
    --version 8.31.2 \
    --namespace $NAMESPACE \
    --create-namespace \
    --set persistence.enabled="false" \
    --set service.type="NodePort" \
    --set auth.erlangCookie=secretcookie \
    --set service.nodePort=$RABBIT_PORT \
    --set service.managerNodePort=$RABBIT_WEB_PORT\
    --set service.distPortEnabled="false" \
    --set service.epmdPortEnabled="false" \
    --set auth.username=$RABBIT_CREDS_USR \
    --set auth.password=$RABBIT_CREDS_PSW \
    --set resources.requests.cpu=30m \
    --set resources.limits.cpu=550m  \
    --set resources.requests.memory=450Mi \
    --set memoryHighWatermark.enabled="true" \
    --set memoryHighWatermark.type="relative" \
    --set memoryHighWatermark.value="0.4" \
    --set resources.limits.memory=1Gi 
