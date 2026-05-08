---
title: 设备断电，Mysql起不来，容器状态restarting
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 设备断电，Mysql起不来，容器状态restarting



## 涉及版本


R23C10


## 问题描述


MySQL无法启动，容器状态为 restarting


## 原因分析


异常断电，mysql数据库损坏


## 解决步骤


/data/1-Mysql-1/conf/my.cnf修改配置文件

innodb_force_recovery=6

innodb_purge_threads=0

重启1-Mysql-1容器正常

docker restat 1-Mysql-1

登录mysql容器执行mysqldump备份全部数据库

docker exec -ti 1-Mysql-1 bash
cd /data
#备份全部数据库
mysqldump -uroot -p'jY%kng8cc&'  --all-databases > all_mysql_backup.sql

停止MySQL容器

备份/data/1-Mysql-1/data目录

备份sql文件到宿主机

docker cp 1-Mysql-1:/data/all_mysql_backup.sql /data/

修改/data/1-Mysql-1/conf/my.cnf修改配置文件，修改回去，重启mysql容器

导入备份sql文件

#先进入data目录
cd /data
#进入mysql容器
docker exec -ti 1-Mysql-1 bash
mysql -uroot -p'jY%kng8cc&'
#恢复数据
source all_mysql_backup.sql
