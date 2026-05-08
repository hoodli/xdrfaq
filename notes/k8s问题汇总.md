---
title: k8s问题汇总
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s问题汇总



## 1、单网口设备，后台迁移IP成功，kubesphere和平台都不能访问


原因：未知

解决步骤：宿主机执行命令

kubectl -n kube-system rollout restart daemonset cilium


## 2、部署报错



### 版本


R25C21


### 现象


time="2025-09-25T16:00:47+08:00" level=fatal msg="failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error mounting "/var/lib/nerdctl/1935db59/containers/k8s.io/69f86f3463ba4fb7d7830be8cc319cec9ff77d2f3f2444b3e32b44840376b7bd/resolv.conf" to rootfs at "/etc/resolv.conf": create mount destination for /etc/resolv.conf mount: bind mount source stat: stat /var/lib/nerdctl/1935db59/containers/k8s.io/69f86f3463ba4fb7d7830be8cc319cec9ff77d2f3f2444b3e32b44840376b7bd/resolv.conf: no such file or directory: unknown"
2025-09-25 16:00:47 INFO Enter ansible with command: sudo nerdctl -n k8s.io exec -w /etc/ansible -ti ansible sh


### 解决


touch /etc/relov.conf


## 3、查看app日志


kubectl get pods -n ailpha-xdr

kubectl exec -ti -n ailpha-xdr dasca-center-7cf994fd7f-tqbjm  bash
cd dasca-app/


![k8s问题汇总_img1.png](../assets/k8s问题汇总/k8s问题汇总_img1.png)



![k8s问题汇总_img2.png](../assets/k8s问题汇总/k8s问题汇总_img2.png)

