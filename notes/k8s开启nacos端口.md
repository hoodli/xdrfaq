---
title: k8s开启nacos端口
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s开启nacos端口



## 步骤



### 后台获取kubesphere的账号密码


sudo kubectl -n kubesphere-system logs `sudo kubectl get pod -n kubesphere-system | grep ks-installer- | awk -F ' ' '{print $1}'`


### 浏览器登录kubesphere


http://10.50.3.252:30881/login


### 创建服务


点创建，服务创建成功后就可以通过端口访问nacos了


### 查看nacos账号密码


通过查看可以确定nacos的账号和密码为：

nacos

bTxUv7rGU*


![k8s开启nacos端口_img1.png](../assets/k8s开启nacos端口/k8s开启nacos端口_img1.png)



![k8s开启nacos端口_img2.png](../assets/k8s开启nacos端口/k8s开启nacos端口_img2.png)



![k8s开启nacos端口_img3.png](../assets/k8s开启nacos端口/k8s开启nacos端口_img3.png)



![k8s开启nacos端口_img4.png](../assets/k8s开启nacos端口/k8s开启nacos端口_img4.png)



![k8s开启nacos端口_img5.png](../assets/k8s开启nacos端口/k8s开启nacos端口_img5.png)



![k8s开启nacos端口_img6.png](../assets/k8s开启nacos端口/k8s开启nacos端口_img6.png)



![k8s开启nacos端口_img7.png](../assets/k8s开启nacos端口/k8s开启nacos端口_img7.png)



![k8s开启nacos端口_img8.png](../assets/k8s开启nacos端口/k8s开启nacos端口_img8.png)

