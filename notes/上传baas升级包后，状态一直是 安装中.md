---
title: 上传baas升级包后，状态一直是 安装中
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 上传baas升级包后，状态一直是 安装中



## 适用版本


V2.0R23C10


## 现象



## 解决步骤


登录mysql通过sql语句修改状态

docker exec -ti 1-Mysql-1 bash
mysql -uroot -p'jY%kng8cc&' bigdata-web
#登录mysql后执行下面这条sql语句
update t_bs_extension_info set status = 'running',result='运行中',is_success = 1 where  code ='baas';
#执行完之后登录mirror页面重启下baas拓展程序


![上传baas升级包后，状态一直是 安装中_img1.png](../assets/上传baas升级包后，状态一直是 安装中/上传baas升级包后，状态一直是 安装中_img1.png)



![上传baas升级包后，状态一直是 安装中_img2.png](../assets/上传baas升级包后，状态一直是 安装中/上传baas升级包后，状态一直是 安装中_img2.png)

