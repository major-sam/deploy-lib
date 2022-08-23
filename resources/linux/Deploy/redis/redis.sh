echo '==============================='
echo 'redis helm chart deploy script'
echo '==============================='
echo $NAMESPACE
echo $REDIS_PORT 
echo '==============================='


/usr/sbin/helm upgrade -i redis bitnami/redis \
    --version 16.5.2 \
    --namespace $NAMESPACE \
    --create-namespace \
    --set master.service.nodePorts.redis=$REDIS_PORT \
    --set master.service.type="NodePort" \
    --set auth.password=$REDIS_CREDS_PSW \
    --set replica.replicaCount=0  \
    --set master.persistence.enabled='false' \
    --set master.resources.requests.cpu=25m \
    --set master.resources.limits.cpu=250m   \
    --set master.resources.requests.memory=250Mi \
    --set master.resources.limits.memory=250Mi 

