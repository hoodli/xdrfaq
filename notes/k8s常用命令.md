---
title: k8s常用命令
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s常用命令



# 适用版本


V2.0R25C21及以上


# 常用命令



## 查看kubesphere密码(30881端口)


sudo kubectl -n kubesphere-system logs `sudo kubectl get pod -n kubesphere-system | grep ks-installer- | awk -F ' ' '{print $1}'`


## 如何进入Mirror


kubectl exec -it -n ailpha-xdr mirror-54c7f659f-6bfhb bash
#这里的mirror名称通过kubectl get pods -n ailpha-xdr获取


## 查看业务侧服务的状态


kubectl get pods -n ailpha-xdr
#可以查看到所有pod的运行状态，这里的pod名称也很关键，后续涉及pod的操作都需要根据实际pod名称修改


## 查看某一个pod的运行日志


kubectl logs -f --tail 200 -n ailpha-xdr mirror-77f974689b-zmcxg
#这里以mirror为例


## 查看pod的状态


kubectl -n ailpha-xdr describe pod mirror-55bd6c9d54-fxq5n


## 查看mysql、redis、nacos的密码


先进入mirror pod：kubectl exec -it -n ailpha-xdr mirror-5cf64c9589-wssbj bash
获取mysql密码：env | grep MYSQL
获取redis密码：env | grep REDIS
获取nacos密码：env | grep NACOS     配置项为：NACOS_AUTH_IDENTITY_VALUE


## 查看kafka端口


kubectl get svc -n kafka


## kafka相关命令


#宿主机拉起kafka-test
kubectl -n kafka run kafka-test --rm -ti --image='ailpha-registry:5000/k8s/kafka:2.13-3.6.0' --command -- bash
#进入目录：
cd /opt/kafka/bin
#查看topic:
./kafka-topics.sh --bootstrap-server kafka-headless.kafka:9092 --list
#创建topic test:
./kafka-topics.sh --bootstrap-server kafka-headless.kafka:9092 --topic test --create
#生产数据：
./kafka-console-producer.sh --bootstrap-server kafka-headless.kafka:9092 --topic com.dbapp.topic.rawevent
#消费数据：
./kafka-console-consumer.sh --bootstrap-server kafka-headless.kafka:9092 --topic com.dbapp.topic.rawevent


## 磁盘读写性能测试


#清理缓存
sync; echo 3 > /proc/sys/vm/drop_caches

#写入测试
time dd if=/dev/zero of=/data/testw.dbf bs=4k count=100000 oflag=direct

#随机读取测试
time dd if=/data/testw.dbf of=/dev/null bs=1M  iflag=direct


## 清理k8s默认策略


kubectl get CiliumClusterwideNetworkPolicy -n kube-system
kubectl get CiliumClusterwideNetworkPolicy -n kube-system | grep -vi name | awk '{print $1}' | xargs -I {} kubectl delete CiliumClusterwideNetworkPolicy -n kube-system {}


## 重启apiserver和proxy


systemctl restart kubelet && systemctl restart containerd


## 查看xdr部署的型号


more /etc/ansible/cluster_init/conf/service-resource.json


## 重启kube-lb服务


systemctl restart kube-lb


## 查看kubesphere端口


kubectl get svc -n kubesphere-system


## 修改mirror内存


kubectl -n ailpha-xdr edit deployment mirror


## 删除posgresql



## 卸载重装


cd /etc/ansible/ && tools/lbctl cluster uninstall
cd /etc/ansible && tools/lbctl cluster deploy


![k8s常用命令_img1.png](../assets/k8s常用命令/k8s常用命令_img1.png)



![k8s常用命令_img2.png](../assets/k8s常用命令/k8s常用命令_img2.png)

