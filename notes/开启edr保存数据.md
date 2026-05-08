---
title: 开启edr保存数据
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 开启edr保存数据



## 适用版本


v2.0R25C22


## 步骤



### 获取kubesphere密码


ssh登录后台执行命令

kubectl -n kubesphere-system logs `sudo kubectl get pod -n kubesphere-system | grep ks-installer- | awk -F ' ' '{print $1}'`


### 登录kubesphere操作


http://10.10.10.10:30881

1.工作负载：happy-data

2.以下值修改为非AXDR就行


![开启edr保存数据_img1.png](../assets/开启edr保存数据/开启edr保存数据_img1.png)



![开启edr保存数据_img2.png](../assets/开启edr保存数据/开启edr保存数据_img2.png)



![开启edr保存数据_img3.png](../assets/开启edr保存数据/开启edr保存数据_img3.png)

