---
title: 已部署后docker gwbridge网段冲突解决方案
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 已部署后docker_gwbridge网段冲突解决方案



## 问题描述


AXDR设备部署现场并接入数据运行一段时间后，发现docker_gwbridge网段与现场冲突


## 适用版本


V2.0R23C10 - V2.0R25C11


## 解决步骤



### 容器重建


#查看哪些容器
docker ps -a --format "{{ .Names }}" -f network=mynet

查询出来的容器内容如下：

1-Baas-1

ailpha-proxy

1-Xdr-1

1-Mirror-1

1-Patrol-1

1-Kafka-1

fluentd

1-Nacos-1

1-Mysql-1

1-Ytagent-1

1-Dasca-center-1

1-Ioa-1

1-Bas-1

1-License-1

1-Dasca-auth-1

1-Dasca-zuul-1

1-Aigent-1

kafka-exporter

1-Grafana-1

1-Prometheus-1

1-Elasticsearch-1

1-Kibana-1

1-Redis-1

1-Clickhouse-1

1-Nginx-1

ailpha-init

ambari-server

ambari-postgresql

1-Mirror-1-agent

1-Aigent-1-agent

1-Elasticsearch-1-agent

1-Baas-1-agent

1-Dasca-auth-1-agent

1-Prometheus-1-agent

1-Xdr-1-agent

1-Redis-1-agent

1-Patrol-1-agent

1-Mysql-1-agent

1-License-1-agent

1-Dasca-center-1-agent

1-Kafka-1-agent

1-Nginx-1-agent

1-Datanode-1

1-Zookeeper-1

1-Clickhouse-1-agent

1-Nacos-1-agent

1-Ytagent-1-agent

1-Kibana-1-agent

1-Snamenode-1

1-Namenode-1

1-Resourcemanager-1

1-Bas-1-agent

1-Grafana-1-agent

1-Ioa-1-agent

1-Dasca-zuul-1-agent

ailpha-registry

上面的查询结果，带agent和对应的容器，可以重建。如 1-Baas-1,1-Baas-1-agent

重建容器的命令

cd /opt/ailpha-install/docker-compose
docker-compose -f docker-compose-node.yml up -d
docker-compose -f docker-compose-appliation.yml up -d


![已部署后docker_gwbridge网段冲突解决方案_img1.png](../assets/已部署后docker_gwbridge网段冲突解决方案/已部署后docker_gwbridge网段冲突解决方案_img1.png)

