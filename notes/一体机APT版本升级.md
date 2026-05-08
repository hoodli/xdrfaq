---
title: 一体机APT版本升级
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 一体机APT版本升级


先升级到 78C05

然后升级到最新

docker exec -ti APT bash
vi /etc/init.d/redis

把sudo -u redis 改成sudo -a redis

然后重启redis服务，

service redis restart

重启tomcat服务

service tomcat restart
