#!/bin/bash
cd $(dirname $0)
#修改下面四个参数，分别为“服务名字”，“namespace”，“解析名字”，“服务端口”
serviceName=wordpress
nameSpace=app-wordpress
#解析地址如gw.gwcloud.tk
appAddress=wp.gwcloud.tk
servicePort=80


# 创建ceph的client_key
ceph_key=$(cat /etc/ceph/ceph.client.admin.keyring | awk /key/{'print $3'} )
cat > ceph-secret.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: ceph-secret
  namespace: ${nameSpace}
data:
  key: ${ceph_key}
EOF

#创建证书
#kubectl create secret tls ingress-secret --namespace=${nameSpace} --key cert/ingress.key --cert cert/ingress.crt

#创建HTTPs的ingress解析，$1为应用名，$2为域名地址
#创建在域名空间app-xxx中，名字为xxx-ingress的配置
cat > ingress.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ${serviceName}-ingress
  namespace: ${nameSpace}
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
spec:
  rules:
  - host: ${appAddress}
    http:
      paths:
      - backend:
          serviceName: ${serviceName}
          servicePort: ${servicePort}
EOF


kubectl apply -f .

