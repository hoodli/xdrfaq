---
title: AXDR：docker gwbridge与客户现场网段冲突
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# AXDR：docker_gwbridge与客户现场网段冲突


docker_gwbridge默认是172.18.0.0/16，与客户现场的网络冲突，需要调整。


## 全量部署，更改部署脚本。


修改/etc/ansible/start.sh脚本

#12.168.16.0/24自己可以随意修改，只要不冲突就行。
docker network create   --subnet 12.168.16.0/24  --opt com.docker.network.bridge.name=docker_gwbridge  --opt com.docker.network.bridge.enable_icc=false  docker_gwbridge

改完之后执行安装脚本

bash start.sh

安装完可以查看网络


![AXDR：docker_gwbridge与客户现场网段冲突_img1.png](../assets/AXDR：docker_gwbridge与客户现场网段冲突/AXDR：docker_gwbridge与客户现场网段冲突_img1.png)



![AXDR：docker_gwbridge与客户现场网段冲突_img2.png](../assets/AXDR：docker_gwbridge与客户现场网段冲突/AXDR：docker_gwbridge与客户现场网段冲突_img2.png)

