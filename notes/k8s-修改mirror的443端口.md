---
title: k8s 修改mirror的443端口
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s-修改mirror的443端口



## 适配版本


R25C21


## 升级包


Index of /release/AXDR/AXDR-V2.0R25C22补丁包/AXDR-V2.0R25C22SPC003


## 步骤



### ssh登录后台修改配置


kubectl -n ingress-nginx edit svc nginx-ingress-controller
#修改nodePort


### 修改apt的检查配置


kubectl -n ailpha-xdr edit deployments.apps apt

在master1后面加上端口信息，如下：


### 升级mirror


升级到版本V2.0R25C22SPC003 ，或者版本为V2.0R25C31以后的版本


### 升级auth


auth链接：https://ip/ailpha-auth/#/login


### nacos修改配置


系统配置-开放端口-开启nacos端口

访问http://ip:18848/nacos/#  用户名密码：nacos/bTxUv7rGU*

编辑global-prod，在文件最后一行增加配置：xdr_access_port=1443 ，然后点击发布


![k8s-修改mirror的443端口_img1.png](../assets/k8s-修改mirror的443端口/k8s-修改mirror的443端口_img1.png)



![k8s-修改mirror的443端口_img2.png](../assets/k8s-修改mirror的443端口/k8s-修改mirror的443端口_img2.png)



![k8s-修改mirror的443端口_img3.png](../assets/k8s-修改mirror的443端口/k8s-修改mirror的443端口_img3.png)



![k8s-修改mirror的443端口_img4.png](../assets/k8s-修改mirror的443端口/k8s-修改mirror的443端口_img4.png)



![k8s-修改mirror的443端口_img5.png](../assets/k8s-修改mirror的443端口/k8s-修改mirror的443端口_img5.png)

