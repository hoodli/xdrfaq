---
title: 后台修改xdr平台名称 k8s
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 后台修改xdr平台名称-k8s



## 适用版本


R25C22


## 需求


修改产品名称


## 步骤


root账号登录后台，root目录创建a.sql文件

update t_common_config set configValue = '安全感知管理平台' where prefix = 'style' and configKey = 'title';

获取mysql密码

#先进入mirror pod,mirror-后面的字符根据实际情况修改
kubectl exec -it -n ailpha-xdr mirror-5cf64c9589-wssbj bash
#获取mysql密码
env | grep MYSQL

将a.sql拷贝到mysql

kubectl cp /root/a.sql mysql-primary-0:/tmp/

登录mysql

kubectl exec -ti -n mysql mysql-primary-0  bash
#这里的dbapp密码改成上一步实际获取的密码
mysql -udbapp -p'1qaz1qaz'
use bigdata-web;
#a.sql是刚开始创建的文件
source /tmp/a.sql
