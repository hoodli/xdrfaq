---
title: k8s 手动创建apt
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s-手动创建apt



## 适配版本


v2.0R25C40


## 现象


安装全量包部署axdr1000型号没有apt容器


## 步骤


cd /etc/ansible/roles/apps/files/charts
mkdir apt-tmp
tar xf apt-v2.0r78c08-lb.tar.gz -C apt-tmp
tar xf apt-2.0.0-r78.c08.tgz -C apt-tmp
cd apt-tmp/apt
cp -a ../docker/values.json .
helm install -n ailpha-xdr apt -f values.json .
kubectl edit deploy -n ailpha-xdr apt
# 把apt image中的大写改为小写

kubectl delete po -n ailpha-xdr <apt pod名称>
# 检查
kubectl get po -n ailpha-xdr | grep apt
