---
title: APT引擎启动提示权限问题解决方案
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# APT引擎启动提示权限问题解决方案



# 步骤



## 修改配置文件


vi /opt/ailpha-install/docker-compose/docker-compose-apt.yml

增加privileged: ture 配置


## 重建APT


cd /opt/ailpha-install/docker-compose
docker-compose -f docker-compose-apt down APT
docker-compose -f docker-compose-apt up -d APT


![APT引擎启动提示权限问题解决方案_img1.png](../assets/APT引擎启动提示权限问题解决方案/APT引擎启动提示权限问题解决方案_img1.png)

