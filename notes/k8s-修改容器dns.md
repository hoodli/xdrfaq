---
title: k8s 修改容器dns
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s-修改容器dns



## 适配版本


v2.0R25C22


## 步骤


vi /opt/kube/resolv.conf
 systemctl restart kubelet
 kubectl rollout restart deploy -n kube-system coredns
