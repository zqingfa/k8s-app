#!/bin/bash

kubectl create secret tls ingress-secret --namespace=$1 --key ingress.key --cert ingress.pem


cat > ingress.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: $1-ingress
  namespace: $1
spec:
  tls:
  - hosts:
    - storage.gwcloud.tk
    secretName: ingress-secret
#    - storage.gwcloud.tk
  rules:
  - host: storage.gwcloud.tk
    http:
      paths:
      - backend:
          serviceName: nextcloud
          servicePort: 80
EOF
