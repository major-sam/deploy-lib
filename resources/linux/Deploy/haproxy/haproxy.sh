/usr/sbin/helm repo add haproxytech https://haproxytech.github.io/helm-charts
/usr/sbin/helm repo update
cat <<EOF > haproxy.yaml
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
    bind website.bb-webapps.com:443 ssl crt $BB_CRT 
    http-request redirect scheme https code 301 unless { ssl_fc }
    default_backend website
  backend website
    mode http
    server web1 $HAPROXY_WEBSITE_BACK check
EOF

/usr/sbin/helm upgrade -i haproxy haproxytech/haproxy \
    --version 1.17.0 \
    --namespace $NAMESPACE \
    --create-namespace \
    -f haproxy.yaml | exit 0
