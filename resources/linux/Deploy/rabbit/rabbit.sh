echo '==============================='
echo 'rabbitmq helm chart deploy script'
echo '==============================='
echo $NAMESPACE
echo $VM_ID
echo $RABBIT_PORT
echo $RABBIT_WEB_PORT
echo '==============================='

/usr/sbin/helm upgrade -i test-rabbitmq bitnami/rabbitmq  \
    --version 8.31.3 \
    --namespace $NAMESPACE \
    --create-namespace \
    --set service.type="NodePort" \
    --set service.nodePort=$RABBIT_PORT \
    --set service.managerNodePort=$RABBIT_WEB_PORT\
    --set auth.username=$REDIS_CREDS_USR \
    --set auth.password=$REDIS_CREDS_PSW$VM_ID  \
    --set resources.requests.cpu=250m \
    --set resources.limits.cpu=250m  \
    --set resources.requests.memory=250Mi \
    --set resources.limits.memory=250Mi
