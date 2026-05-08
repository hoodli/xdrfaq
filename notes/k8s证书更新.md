---
title: k8s证书更新
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s证书更新



# 报错现象：



# 解决步骤


登录k8s 任意一个master节点，运行以下命令检查当前集群证书状态：

kubeadm certs check-expiration

主要关注"RESIDUAL TIME"剩余时间，建议在证书过期前90天进行更新.

在所有master 节点上更新集群证书，续期一年：

kubeadm certs renew all
kubeadm init phase kubeconfig all

没有报错说明证书更新完成，可以再次运行第一步的命令检查证书剩余时间.

注意：第二条命令如果运行出现以上报错，即无法生成新的配置文件（一般在服务器更换 IP 之后会出现），那么需要手动删除掉旧的配置，然后重新运行第二条命令生成：

cp -a /etc/kubernetes{,.bak}
rm -f /etc/kubernetes/*.conf
# 重新运行
kubeadm init phase kubeconfig all


![k8s证书更新_img1.png](../assets/k8s证书更新/k8s证书更新_img1.png)



![k8s证书更新_img2.png](../assets/k8s证书更新/k8s证书更新_img2.png)



![k8s证书更新_img3.png](../assets/k8s证书更新/k8s证书更新_img3.png)



![k8s证书更新_img4.png](../assets/k8s证书更新/k8s证书更新_img4.png)

