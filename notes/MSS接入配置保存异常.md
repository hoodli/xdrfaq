---
title: MSS接入配置保存异常
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# MSS接入配置保存异常



## 版本


V2.0R25C10


## 问题现象



## 后台日志



## 解决步骤


docker exec -ti 1-Mysql-1 bash
mysql -uroot -p'jY%kng8cc&'
use bigdata-web;
update t_mss_agent_config set customer_unit_name = 'test';


![MSS接入配置保存异常_img1.png](../assets/MSS接入配置保存异常/MSS接入配置保存异常_img1.png)



![MSS接入配置保存异常_img2.png](../assets/MSS接入配置保存异常/MSS接入配置保存异常_img2.png)

