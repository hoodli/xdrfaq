---
title: 告警数据迁移至AXDR R25c21
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 告警数据迁移至AXDR R25c21



# 需求


该文档解决

AXDR的v2.0.4\v2.0.5版本以及ailpha的A680、A690型号

设备告警备份迁移到 AXDR R25C21的需求


# 所需工具


x86

请至钉钉文档查看附件《linux64-5.0.tar.gz》

arm

请至钉钉文档查看附件《esdump_arm64.tar.gz》


# 操作步骤



## axdr老版本(v2.0.4\v2.0.5)或ailpha环境操作



#### 关闭平台流计算任务。


确保没有新的告警数据产生写入到es


#### 上传工具



#### 将linux64-5.0.tar.gz传到平台的1.es1容器/data目录，并解压


#把linux64-5.0.tar.gz传到1.es1容器/data目录
cp linux64-5.0.tar.gz  /data/data_1.es1/
#进入1.es1容器
docker exec -ti 1.es1 bash
cd /data
#解压工具包
tar -xzvf linux64-5.0.tar.gz


#### 获取当前es的索引信息


sh esdump.sh 127.0.0.1:9200

执⾏完脚本会在当前⽬录⾃动⽣成⼀个index.txt的⽂件，如上图。index.txt⽂件⾥⾯的
索引名称是Elasticsearch上的索引,编辑index.txt文件，保留alarm索引，删除其他索引


#### 备份索引并保存到当前目录


sh esdumpbin.sh 127.0.0.1:9200

备份的索引下载保存到笔记本电脑。


## xdr(r23c10版本)



#### 关闭平台流计算任务。


确保没有新的告警数据产生写入到es


#### 上传工具



#### 将linux64-5.0.tar.gz传到平台的1.es1容器/data目录，并解压


#把linux64-5.0.tar.gz传到1.es1容器/data目录
cp linux64-5.0.tar.gz  /data/1-Elasticsearch-1/data/
#进入1.es1容器
docker exec -ti 1-Elasticsearch-1 bash
cd /usr/share/elasticsearch/data
#解压工具包
tar -xzvf linux64-5.0.tar.gz


#### 获取当前es的索引信息


sh esdump.sh 127.0.0.1:9200

执⾏完脚本会在当前⽬录⾃动⽣成⼀个index.txt的⽂件，如上图。index.txt⽂件⾥⾯的
索引名称是Elasticsearch上的索引,编辑index.txt文件，保留alarm索引，删除其他索引


#### 备份索引并保存到当前目录


sh esdumpbin.sh 127.0.0.1:9200

备份的索引下载保存到笔记本电脑。


## AXDR R25C21环境操作



#### 关闭流计算任务


保证mysql、es数据没有新的数据写入。用账号ailpha登录，停止流计算任务。


#### 登录kubesphere映射ES端口



##### 获取kubesphere密码


kubectl -n kubesphere-system logs `kubectl get pod -n kubesphere-system | grep ks-installer- | awk -F ' ' '{print $1}'`


##### 登录kubesphere映射es端口


操作完可以看到映射后的端口为 53066，端口是随机产生的。


#### 上传包到后台并解压


#解压命令
tar -xzvf linux64-5.0.tar.gz
cd linux64/


#### 恢复索引数据


确认index.txt⾥的索引名称以及对应的索引是否在当前⽬录
(刚才备份的ailpha-baas-alarm-2025-000001.bin索引)

确认index.txt文件内容是否如下

index

ailpha-baas-alarm-2025-000001

执行索引导入脚本

sh esimport.sh 10.10.10.11:53066
#10.10.10.11改成现场服务器的IP地址
#53066端口改成现场生成的端口


![告警数据迁移至AXDR R25c21_img1.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img1.png)



![告警数据迁移至AXDR R25c21_img2.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img2.png)



![告警数据迁移至AXDR R25c21_img3.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img3.png)



![告警数据迁移至AXDR R25c21_img4.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img4.png)



![告警数据迁移至AXDR R25c21_img5.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img5.png)



![告警数据迁移至AXDR R25c21_img6.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img6.png)



![告警数据迁移至AXDR R25c21_img7.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img7.png)



![告警数据迁移至AXDR R25c21_img8.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img8.png)



![告警数据迁移至AXDR R25c21_img9.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img9.png)



![告警数据迁移至AXDR R25c21_img10.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img10.png)



![告警数据迁移至AXDR R25c21_img11.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img11.png)



![告警数据迁移至AXDR R25c21_img12.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img12.png)



![告警数据迁移至AXDR R25c21_img13.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img13.png)



![告警数据迁移至AXDR R25c21_img14.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img14.png)



![告警数据迁移至AXDR R25c21_img15.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img15.png)



![告警数据迁移至AXDR R25c21_img16.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img16.png)



![告警数据迁移至AXDR R25c21_img17.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img17.png)



![告警数据迁移至AXDR R25c21_img18.png](../assets/告警数据迁移至AXDR R25c21/告警数据迁移至AXDR R25c21_img18.png)

