---
title: redies启动失败
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# redies启动失败



## 版本


R25C11


## 现象



## 原因


设备断电或异常关机


## 解决步骤


cd /data/1-Redis-1/data
rm appendonly.aof
#重启redis容器
docker restart 1-Redis-1
#查看redis容器状态
docker ps |grep 1-Redis-1


![redies启动失败_img1.png](../assets/redies启动失败/redies启动失败_img1.png)



![redies启动失败_img2.png](../assets/redies启动失败/redies启动失败_img2.png)

