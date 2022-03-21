#!/bin/bash

echo 'redis helm chart deploy script'

namespace = $env.ns
redisPort = $env.REDIS_PORT
rabbitPort = $env.RABBIT_PORT
rabbitwebPort = $env.RABBIT_WEB_PORT
redisPwd = $env.REDIS_PWD
rabbitUsr = $env.RABBIT_USR
rabbitPwd = $env.RABBIT_PWD

while (( $# > 1 )); do case $1 in
   --port) redisPort="$2";;
   --password) redisPwd="$2";;
   --namespace) namespace="$2";;
   *) break;
 esac; shift 2
done


/usr/sbin/helm upgrade -i redis bitnami/redis \
    --version 16.5.2 \
    --namespace $namespace \
    --create-namespace \
    --set master.service.nodePorts.redis=$redisPort \
    --set master.service.type="NodePort" \
    --set auth.password=$redisPwd
