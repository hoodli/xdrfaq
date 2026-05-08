---
title: 替换APT镜像
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 替换APT镜像



# 适用版本


R23C10-R25C11


# 步骤



## 停止APT容器


cd /opt/ailpha-install/docker-compose
docker-compose -f docker-compose-apt.yml down APT


## 检查APT容器是否已经删除


ps -ef | grep APT


## 上传新的镜像包到/root 目录并导入


docker load -i aptsp_2.0R78C07.tar.gz


## 检查是否导入成功


docker image ls | grep apt


## 修改docker-compose-apt.yml文件


cd /opt/ailpha-install/docker-compose
vi docker-compose-apt.yml

把 aptsp:v2.0R78C02  改成 aptsp:v2.0R78C07

version: "3"
services:
 apt:
 image: aptsp:v2.0R78C02
 container_name: "APT"
 hostname: "APT"
 network_mode: host
 cpuset: '0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23'
 volumes:
 - /lib/modules:/lib/modules
 - /dev:/dev
 - /var/lib/d_machines:/var/lib/d_machines
 - /var/lib/dbus/machine-id:/var/lib/dbus/machine-id
 - /etc/machine-id:/etc/machine-id
 - /data/apt/daslicense:/home/webdefender/conf/daslicense
 cap_add:
 - NET_ADMIN
 environment:
 - TZ=Asia/Shanghai
 - KAFKA_SERVERS=127.0.0.1:19091
 - MIRROR_SERVER_ADDRESS=10.50.28.52
 env_file:
 - midware.env
 ulimits:
 nofile:
 soft: 262144
 hard: 262144
 deploy:
 restart_policy:
 condition: unless-stopped
 resources:


## 拉起APT


cd /opt/ailpha-install/docker-compose
docker-compose -f docker-compose-apt.yml up -d  APT


## 等到APT平台可正常访问后，重新同步APT许可



![替换APT镜像_img1.png](../assets/替换APT镜像/替换APT镜像_img1.png)



![替换APT镜像_img2.png](../assets/替换APT镜像/替换APT镜像_img2.png)

