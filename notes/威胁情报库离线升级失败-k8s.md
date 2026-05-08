---
title: 威胁情报库离线升级失败 k8s
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 威胁情报库离线升级失败-k8s



## 适配版本


V2.0R25C21


## 问题现象



## 解决步骤



### 修改mirror内存


把10G改成20G


### 重新创建



### 修改java参数


cd bin
vi mirror-cli.sh
#把Xmx6G 改成Xmx18G

#重启mirror服务
./mirror-cli.sh restart
#查看是否已经生效
ps -ef |grep java

重新申请情报文件


![威胁情报库离线升级失败-k8s_img1.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img1.png)



![威胁情报库离线升级失败-k8s_img2.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img2.png)



![威胁情报库离线升级失败-k8s_img3.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img3.png)



![威胁情报库离线升级失败-k8s_img4.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img4.png)



![威胁情报库离线升级失败-k8s_img5.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img5.png)



![威胁情报库离线升级失败-k8s_img6.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img6.png)



![威胁情报库离线升级失败-k8s_img7.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img7.png)



![威胁情报库离线升级失败-k8s_img8.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img8.png)



![威胁情报库离线升级失败-k8s_img9.png](../assets/威胁情报库离线升级失败-k8s/威胁情报库离线升级失败-k8s_img9.png)

