---
title: ailpha a680 a690 告警数据迁移至AXDR r25c10
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# ailpha a680\a690 告警数据迁移至AXDR r25c10



# 需求


该文档解决ailpha的A680、A690型号设备告警备份迁移到 AXDR r25c10的需求


# 所需工具


请至钉钉文档查看附件《linux64-5.0.tar.gz》


# 操作步骤



## ailpha环境操作



#### 关闭ailpha的流计算任务。


确保没有新的告警数据产生写入到es


#### 上传工具



#### 将linux64-5.0.tar.gz传到ailpha服务器的1.es1容器/data目录，并解压


#把linux64-5.0.tar.gz传到1.es1容器/data目录
cp linux64-5.0.tar.gz  /data/data_1.es1/
#进入1.es1容器
docker exec -ti 1.es1 bash
cd /data
#解压工具包
tar -xzvf linux64-5.0.tar.gz


#### 获取当前es的索引信息


sh esdump.sh 127.0.0.1：9200

执⾏完脚本会在当前⽬录⾃动⽣成⼀个index.txt的⽂件，如上图。index.txt⽂件⾥⾯的
索引名称是Elasticsearch上的索引,编辑index.txt文件，保留alarm索引，删除其他索引


#### 备份索引并保存到当前目录


sh esdumpbin.sh 10.10.10.10:9200

备份的索引下载保存到笔记本电脑。


## AXDR环境操作



#### 关闭流计算任务


保证mysql、es数据没有新的数据写入。用账号ailpha登录，停止流计算任务


#### 映射es端口到49200


docker exec -ti 1-Mirror-1 bash
curl -XPOST http://ailpha-init:8000/api/v1/cluster/port -d '{"service":"Elasticsearch", "inport": "9200","outport":"49200","type":"tcp"}'


#### 上传包到后台并解压


#解压命令
tar -xzvf linux64-5.0.tar.gz


#### 恢复索引数据


确认index.txt⾥的索引名称以及对应的索引是否在当前⽬录
(刚才备份的ailpha-baas-alarm-2025-000001.bin索引)

确认index.txt文件内容是否如下

index

ailpha-baas-alarm-2025-000001

执行索引导入脚本

sh eximport.sh 10.10.10.11:49200
#10.10.10.11改成现场服务器的IP地址


![ailpha a680_a690 告警数据迁移至AXDR r25c10_img1.png](../assets/ailpha a680_a690 告警数据迁移至AXDR r25c10/ailpha a680_a690 告警数据迁移至AXDR r25c10_img1.png)



![ailpha a680_a690 告警数据迁移至AXDR r25c10_img2.png](../assets/ailpha a680_a690 告警数据迁移至AXDR r25c10/ailpha a680_a690 告警数据迁移至AXDR r25c10_img2.png)



![ailpha a680_a690 告警数据迁移至AXDR r25c10_img3.png](../assets/ailpha a680_a690 告警数据迁移至AXDR r25c10/ailpha a680_a690 告警数据迁移至AXDR r25c10_img3.png)



![ailpha a680_a690 告警数据迁移至AXDR r25c10_img4.png](../assets/ailpha a680_a690 告警数据迁移至AXDR r25c10/ailpha a680_a690 告警数据迁移至AXDR r25c10_img4.png)



![ailpha a680_a690 告警数据迁移至AXDR r25c10_img5.png](../assets/ailpha a680_a690 告警数据迁移至AXDR r25c10/ailpha a680_a690 告警数据迁移至AXDR r25c10_img5.png)



![ailpha a680_a690 告警数据迁移至AXDR r25c10_img6.png](../assets/ailpha a680_a690 告警数据迁移至AXDR r25c10/ailpha a680_a690 告警数据迁移至AXDR r25c10_img6.png)

