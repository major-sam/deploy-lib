/usr/sbin/helm repo add haproxytech https://haproxytech.github.io/helm-charts
/usr/sbin/helm repo update
cp $BB_CRT ./cert.crt
cp $BB_KEY ./cert.crt.key
cat <<EOF > haproxy.yaml
kind: DaemonSet
containerPorts:
  http: 80
  https: 443
  stat: 1024
daemonset:
  useHostNetwork: true
  useHostPort: true
  hostPorts:
    http: 80
    https: 443
    stat: 1024
config: |
  global
    log stdout format raw local0
    daemon
    lua-load /etc/haproxy/lua/cors.lua
    maxconn 1024
  frontend stats
    mode http
    bind *:1024
    no log
    stats enable
    stats uri /stats
    stats refresh 10s
  defaults
    log global
    timeout client 60s
    timeout connect 60s
    timeout server 60s
  frontend default
    mode http
    bind *:443 ssl crt /usr/local/etc/ssl/cert.crt 
    http-request redirect scheme https code 301 unless { ssl_fc }
    http-request lua.cors "*" "*" "*"
    use_backend %[req.hdr(host),lower,map(/etc/haproxy/maps/hosts.map,be_default)]
    default_backend website

  backend livemoncontent
    mode http 
    server web1 $agent_ip:$livemonitor_content_port check

  backend website
    mode http 
    http-response lua.cors
    http-response add-header access-control-allow-origin "*"
    http-response add-header access-control-allow-headers "*"
    http-response add-header access-control-max-age 3600
    http-response add-header access-control-allow-methods "get, delete, options, post, put, patch"
    server web1 $agent_ip:$website_http_port check
initContainers:
  - name: sysctl
    image: "busybox:musl"
    command:
      - /bin/sh
      - -c
      - sysctl -w net.ipv4.ip_unprivileged_port_start=0
    securityContext:
      privileged: true
mountedSecrets:
  - volumeName: maps
    secretName: maps
    mountPath: /etc/haproxy/maps
  - volumeName: ssl-certificate
    secretName: bb-cert
    mountPath: /usr/local/etc/ssl
  - volumeName: cors-lua
    secretName: cors-lua
    mountPath: /etc/haproxy/lua/
EOF
/usr/bin/kubectl create secret --namespace=$NAMESPACE generic maps \
  --from-file=./hosts.map
/usr/bin/kubectl create secret --namespace=$NAMESPACE generic cors-lua \
  --from-file=./cors.lua
/usr/bin/kubectl create secret --namespace=$NAMESPACE generic bb-cert \
  --from-file=./cert.crt --from-file=./cert.crt.key 
/usr/sbin/helm upgrade -i haproxy haproxytech/haproxy \
    --version 1.17.0 \
    --namespace $NAMESPACE \
    --set replicaCount=0 \
    --create-namespace \
    -f haproxy.yaml 
