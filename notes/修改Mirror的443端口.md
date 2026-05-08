---
title: 修改Mirror的443端口
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 修改Mirror的443端口



# 适用版本


R25C10-R25C11


# 步骤



## 修改docker-compose-midware-application.yml文件


cd /opt/ailpha-install/docker-compose/
vi docker-compose-midware-application.yml

比如把443改成9443


## 重建Nginx容器


docker-compose  -f docker-compose-midware-application.yml  up -d  1-Nginx-1


## 校验


docker ps |grep Nginx


![修改Mirror的443端口_img1.png](../assets/修改Mirror的443端口/修改Mirror的443端口_img1.png)



![修改Mirror的443端口_img2.png](../assets/修改Mirror的443端口/修改Mirror的443端口_img2.png)

