---
title: k8s底座如何查看密码
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s底座如何查看密码


1、先到后台执行命令，获取k8s登录密码

kubectl -n kubesphere-system logs `kubectl get pod -n kubesphere-system | grep ks-installer- | awk -F ' ' '{print $1}'`

2、登录k8s界面http://10.20.183.12:30881，账号为admin，初始密码就看步骤1

3、登录后按照以下步骤进入页面

这个页面可以查看各个组件的密码


![k8s底座如何查看密码_img1.png](../assets/k8s底座如何查看密码/k8s底座如何查看密码_img1.png)



![k8s底座如何查看密码_img2.png](../assets/k8s底座如何查看密码/k8s底座如何查看密码_img2.png)



![k8s底座如何查看密码_img3.png](../assets/k8s底座如何查看密码/k8s底座如何查看密码_img3.png)



![k8s底座如何查看密码_img4.png](../assets/k8s底座如何查看密码/k8s底座如何查看密码_img4.png)



![k8s底座如何查看密码_img5.png](../assets/k8s底座如何查看密码/k8s底座如何查看密码_img5.png)



![k8s底座如何查看密码_img6.png](../assets/k8s底座如何查看密码/k8s底座如何查看密码_img6.png)

