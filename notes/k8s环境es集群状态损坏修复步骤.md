---
title: k8s环境es集群状态损坏修复步骤
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s环境es集群状态损坏修复步骤



## 适配版本


V2.0R25C22


## 现象


es集群无法启动，查看es master日志

kubectl -n elastic logs -f --tail 100 elasticsearch-es-master-0


### 日志示例


[2026-04-08T10:28:46,444][ERROR][o.e.b.ElasticsearchUncaughtExceptionHandler] [elasticsearch-es-master-0] uncaught exception in thread [main]
org.elasticsearch.bootstrap.StartupException: ElasticsearchException[failed to bind service]; nested: CorruptIndexException[codec header mismatch: actual header=1885696609 vs expected header=1071082519 (resource=NIOFSIndexInput(path="/usr/share/elasticsearch/data/nodes/0/_state/_7dz.cfs"))];


## 所需脚本


请至钉钉文档查看附件《index_alias.sh》。

请至钉钉文档查看附件《allocation_es_shard_k8s.sh》。


## 解决步骤


1、查找master节点数据目录

kubectl -n elastic get pvc | grep master
kubectl -n elastic get pv pvc-xxx -o yaml | grep path:

2、进入master数据目录，移除所有集群状态文件

mv nodes/0/_state/* /tmp/es-bak/

3、所有es节点添加配置，发现游离索引

kubectl -n elastic get elasticsearch elasticsearch -o yaml > es.yaml

修改es.yaml文件内容，nodeSets下每个节点的配置都加上：gateway.auto_import_dangling_indices: true

然后执行命令

kubectl apply -f es.yaml

4、修改es master sts，使不启动服务，但能进入到pod里

kubectl -n elastic edit sts elasticsearch-es-master

在name: elasticsearch下面添加

command: ["/bin/sleep", "infinity"]

#重启
kubectl -n elastic delete pod sts elasticsearch-es-master-0

5、进入es master pod中，强制指定master，重新初始化集群

bin/elasticsearch-node unsafe-bootstrap

6、再修改es master sts，重启master

kubectl -n elastic edit sts elasticsearch-es-master

去掉command: ["/bin/sleep", "infinity"]

kubectl -n elastic delete pod sts elasticsearch-es-master-0

7、其他data节点也依次进行4、本步骤、6

bin/elasticsearch-node detach-cluster

8、等待es集群恢复，重置掉无法恢复得分片

在elasticsearch-es-master-0 pod中，执行allocation_es_shard_k8s.sh脚本

观察es恢复情况

9、添加缺失的别名信息

在elasticsearch-es-master-0 pod中，执行index_alias.sh脚本

# 拷贝到 /tmp 目录
kubectl cp /root/index_alias.sh elastic/elasticsearch-es-master-0:/tmp/index_alias.sh

# 验证文件是否拷贝成功
kubectl exec -it elasticsearch-es-master-0 -n elastic -- ls -la /tmp/index_alias.sh

# 如果需要执行脚本，可以加执行权限（在 /tmp 下）
kubectl exec -it elasticsearch-es-master-0 -n elastic -- chmod +x /tmp/index_alias.sh

#登录pod执行脚本
kubectl exec -ti -n elatic elasticsearch-es-master-0 bash
bash /tmp/index_alias.sh
