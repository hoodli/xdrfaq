---
title: 非标准硬件配置设备部署AXDR(256G内存)
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 非标准硬件配置设备部署AXDR(256G内存)



## 适用版本


V2.0R25C21


## 场景


在内存256G的设备上部署AXDR的990、1000、1500型号，需要手动修改配置文件


## 方法一


sudo tools/lbctl cluster reset
sudo tools/lbctl cluster init
sudo tools/lbctl node add master 172.22.15.40 -uroot -p'1qazcde3!@#' -P22
sudo tools/lbctl cluster set -t AXDR1500
#上面的IP、账号、密码、型号需根据现场实际情况调整
#执行完上面的命令之后，会生成serv ice-resource.json文件
vi /etc/ansible/cluster_init/conf/service-resource.json
#修改elasticsearch模块的配置，将对应型号的数值改成0.08,修改完后继续安装命令
cd /etc/ansible
tools/lbctl cluster deploy


## 方法二


kubectl -n elastic edit elasticsearches.elasticsearch.k8s.elastic.co elasticsearch

修改2个地方

都减半，比如

limits.memory 设置为：24015Mi

request.memory 设置为：12007Mi


![非标准硬件配置设备部署AXDR(256G内存)_img1.png](../assets/非标准硬件配置设备部署AXDR(256G内存)/非标准硬件配置设备部署AXDR(256G内存)_img1.png)



![非标准硬件配置设备部署AXDR(256G内存)_img2.png](../assets/非标准硬件配置设备部署AXDR(256G内存)/非标准硬件配置设备部署AXDR(256G内存)_img2.png)



![非标准硬件配置设备部署AXDR(256G内存)_img3.png](../assets/非标准硬件配置设备部署AXDR(256G内存)/非标准硬件配置设备部署AXDR(256G内存)_img3.png)

