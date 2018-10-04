#!/bin/bash
cd $(dirname $0)
# 1.运行ceph创建脚本
bash createCeph.sh

# 2.创建ceph-secret的yaml,并运行
ceph-Key=`cat /etc/ceph/admin.secret`
cat > ceph-secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ceph-secret
  namespace: gwhospital
data:
  key: ${ceph-Key}
EOF

# 3.创建namespaces
kubectl create namespace hospital
kubectl apply -f ceph-secret.yaml