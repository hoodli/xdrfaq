---
title: k8s 断电后多个服务无法启动(redis异常导致)
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s-断电后多个服务无法启动(redis异常导致)



## 适用版本


R25C21


## 问题现象



## 处理步骤


kubectl describe pod -n redis redis-node-0
kubectl get pvc -n redis redis-data-redis-node-0 -o yaml
kubectl get pv pvc-b3cf7c6e-c937-4336-83ab-9ffd00220b55 -o yaml
cd /data/local_path/k8s_data/pvc-b3cf7c6e-c937-4336-83ab-9ffd00220b55_redis_redis-data-redis-node-0/appendonlydir/
mv appendonly.aof.2.incr.aof appendonly.aof.2.incr.aof-bak
mv appendonly.aof.manifest appendonly.aof.manifest-bak
kubectl delete pod -n redis redis-node-0


![k8s-断电后多个服务无法启动(redis异常导致)_img1.png](../assets/k8s-断电后多个服务无法启动(redis异常导致)/k8s-断电后多个服务无法启动(redis异常导致)_img1.png)

