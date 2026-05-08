---
title: apt首页流量不显示问题
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# apt首页流量不显示问题


临时方法就是

vi /etc/init.d/redis

把sudo -u redis 改成sudo -a redis

然后重启redis服务

service restart redis


![apt首页流量不显示问题_img1.png](../assets/apt首页流量不显示问题/apt首页流量不显示问题_img1.png)

