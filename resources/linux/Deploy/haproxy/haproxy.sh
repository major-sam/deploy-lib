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
    maxconn 1024
  defaults
    log global
    timeout client 60s
    timeout connect 60s
    timeout server 60s
  frontend website
    mode http
    bind *:443 ssl crt /usr/local/etc/ssl/cert.crt 
    http-request redirect scheme https code 301 unless { ssl_fc }
    default_backend website
  backend website
    mode http
    server web1 $AGENT_IP:$WEBSITE_HTTP_PORT check
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
  - volumeName: ssl-certificate
    secretName: bb-cert
    mountPath: /usr/local/etc/ssl
EOF
/usr/bin/kubectl create secret --namespace=$NAMESPACE generic bb-cert \
  --from-file=./cert.crt --from-file=./cert.crt.key 
/usr/sbin/helm upgrade -i haproxy haproxytech/haproxy \
    --version 1.17.0 \
    --namespace $NAMESPACE \
    --set replicaCount=0 \
    --create-namespace \
    -f haproxy.yaml 
