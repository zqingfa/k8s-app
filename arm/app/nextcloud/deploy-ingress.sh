#!/bin/bash
#修改下面四个参数，分别为“服务名字”，“namespace”，“解析名字”，“服务端口”
serviceName=storage
nameSpace=app-storage
#解析地址如gw.gwcloud.tk
appAddress=storage.gwcloud.tk
servicePort=80

#创建证书
kubectl create secret tls ingress-secret --namespace=${nameSpace} --key cert/ingress.key --cert cert/ingress.crt
#创建HTTPs的ingress解析，$1为应用名，$2为域名地址
#创建在域名空间app-xxx中，名字为xxx-ingress的配置
cat > ingress.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ${serviceName}-ingress
  namespace: ${nameSpace}
spec:
  tls:
  - hosts:
    - ${appAddress}
    secretName: ingress-secret
  rules:
  - host: ${appAddress}
    http:
      paths:
      - backend:
          serviceName: ${serviceName}
          servicePort: ${servicePort}
EOF
kubectl apply -f ingress.yaml