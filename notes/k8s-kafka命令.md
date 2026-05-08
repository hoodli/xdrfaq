---
title: k8s kafka命令
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s-kafka命令



## 适配版本


v2.0R25C22


## 步骤


宿主机：kubectl -n kafka run kafka-test --rm -ti --image='ailpha-registry:5000/k8s/kafka:2.13-3.6.0' --command -- bash
进入目录：cd /opt/kafka/bin
查看topic:
./kafka-topics.sh --bootstrap-server kafka-headless.kafka:9092 --list
创建topic:
./kafka-topics.sh --bootstrap-server kafka-headless.kafka:9092 --topic test --create
生产数据：
./kafka-console-producer.sh --bootstrap-server kafka-headless.kafka:9092 --topic com.dbapp.topic.rawevent
消费数据：
./kafka-console-consumer.sh --bootstrap-server kafka-headless.kafka:9092 --topic com.dbapp.topic.rawevent
