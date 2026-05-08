---
title: 如何查看dasca的app日志
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 如何查看dasca的app日志



## 适配版本


v2.0R25C21及以后


## 步骤


kubectl  get pods -n ailpha-xdr
kubectl exec -ti -n ailpha-xdr   dasca-center-7cf994fd7f-tqbjm  bash

进入到对应的目录查看日志

cd dasca-app/

#这里以edr为例
cd dasca-dbappsecurity-edrv7/dasca-dbappsecurity-edrv7/logs/
tail -f info.log
#app的日志数据保存在info和error文件里。


![如何查看dasca的app日志_img1.png](../assets/如何查看dasca的app日志/如何查看dasca的app日志_img1.png)



![如何查看dasca的app日志_img2.png](../assets/如何查看dasca的app日志/如何查看dasca的app日志_img2.png)



![如何查看dasca的app日志_img3.png](../assets/如何查看dasca的app日志/如何查看dasca的app日志_img3.png)

