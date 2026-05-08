---
title: k8s 数据量大系统很卡，常见问题汇总
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s-数据量大系统很卡，常见问题汇总



### 现场1: 升级软件包失败


把流计算任务先停止了 再升级


### 现象2: 执行kubectl get pods -A 获取失败


重启底座服务

systemctl restart etcd

systemctl restart kube-lb

如果还不行

/etc/kubernetes/manifests/ 下的 kube-*.yaml 移到外面

等 nerdctl -n k8s.io ps | grep kube-api 消失

nerdctl -n k8s.io ps | grep kube-controll

nerdctl -n k8s.io ps | grep kube-sche

nerdctl -n k8s.io stop  前面的id

全部停止完之后   把哪些yaml文件放回去

重启下kubelet服务，systemctl start kubelet


### 现象3: 流计算任务一起来就系统开始卡，各种问题就出现了，手动停止流计算任务


先在baas库中关闭流计算任务任务的自动拉起

kubectl -n postgresql exec -it postgresql-cluster-0 bash

psql -U dbapp -d postgres -h postgresql-cluster.postgresql

输入PG密码

set search_path to baas_monitor;

update t_solution set pull_up_auto=false

执行下面命令：

systemctl stop kubelet

ls /var/log/containers/ | grep flink | awk -F'_' '{print $3}' | awk -F'-'  '{print $NF}' | sed  "s/\.log//g" | xargs -I {} nerdctl -n k8s.io stop {}

如果还是没有停，则使用 kubectl delete po n ailpha xdr flink-xxxx --force   删除flink开头的4个pod
