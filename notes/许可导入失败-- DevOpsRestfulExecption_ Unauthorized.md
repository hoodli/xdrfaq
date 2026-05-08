---
title: 许可导入失败   DevOpsRestfulExecption  Unauthorized
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 许可导入失败-- DevOpsRestfulExecption: Unauthorized



## 适配版本


r25c22


## 原因


调用运维底座接口提示无权限导致的


## 解决步骤


执行下面命令，重启cilium

kubectl -n kube-system rollout  restart deployment cilium-operator
kubectl -n kube-system rollout  restart daemonset cilium
