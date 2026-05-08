---
title: 过网闸访问AXDR
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 过网闸访问AXDR



## 适配版本


R25C21及以后


## 需求


axdr部署在内网，通过IP映射到外网，允许外网访问axdr


## 解决步骤



### 获取nacos密码


#获取mirror名称
kubectl get pods  -n ailpha-xdr
#先进入mirror pod，mirror-后面的字符串根据上一步获取到的更改
kubectl exec -it -n ailpha-xdr mirror-5cf64c9589-wssbj bash
#获取nacos密码，配置项为：NACOS_AUTH_IDENTITY_VALUE
env | grep NACOS


### 打开nacos端口



### 登录nacos配置


ip根据实际情况修改

http://192.168.30.73:18848/nacos

账号：  nacos

密码刚才获取到的


#### 选中ailpha_xdr


将IP添加后，点发布

文件：core-prod

将IP添加后，点发布


![过网闸访问AXDR_img1.png](../assets/过网闸访问AXDR/过网闸访问AXDR_img1.png)



![过网闸访问AXDR_img2.png](../assets/过网闸访问AXDR/过网闸访问AXDR_img2.png)



![过网闸访问AXDR_img3.png](../assets/过网闸访问AXDR/过网闸访问AXDR_img3.png)



![过网闸访问AXDR_img4.png](../assets/过网闸访问AXDR/过网闸访问AXDR_img4.png)



![过网闸访问AXDR_img5.png](../assets/过网闸访问AXDR/过网闸访问AXDR_img5.png)



![过网闸访问AXDR_img6.png](../assets/过网闸访问AXDR/过网闸访问AXDR_img6.png)

