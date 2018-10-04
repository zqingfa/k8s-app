#!/bin/bash
ceph_Moniter=k8s-master


#创建ceph的clinet的key,并挂载到/mnt
cat /etc/ceph/ceph.client.admin.keyring | awk /key/{'print $3'} > /etc/ceph/admin.secret
mount -t ceph ${ceph_Moniter}:/ /mnt -o name=admin,secretfile=/etc/ceph/admin.secret
#进入ceph主目录,并创建相应目录
cd /mnt

mkdir -p gwhospital/01rabbitmq/mnesia
mkdir -p gwhospital/02svn/svn
mkdir -p gwhospital/03discovery/data
mkdir -p gwhospital/04config/ter_config
mkdir -p gwhospital/05fastdfs/fastdfs
mkdir -p gwhospital/06redis/redis
mkdir -p gwhospital/07activemq/activemq
mkdir -p gwhospital/08mysql/mysql
mkdir -p gwhospital/09iomsgateway/data
mkdir -p gwhospital/10iomsums/data
mkdir -p gwhospital/11iomsmonitor/data
mkdir -p gwhospital/12iomsmq/data
mkdir -p gwhospital/13ui/www

chmod 777 -R gwhospital
#返回原目录
cd -

umount /mnt