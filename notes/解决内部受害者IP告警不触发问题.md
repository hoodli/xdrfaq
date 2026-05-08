---
title: 解决内部受害者IP告警不触发问题
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 解决内部受害者IP告警不触发问题



## 适配版本


R25C21


## 问题现象


攻击者和受攻击者的IP都为内部IP时，告警无法在xdr展示


## 解决步骤


#登录xdr一体机中的apt
kubectl exec -it -n ailpha-xdr $(kubectl get pods -n ailpha-xdr -o name | grep apt-) -- /bin/bash
#修改wdd.cfg文件
vi /home/webdefender/conf/wdd.cfg
#在[SYS]模块里新增内容
anomalous_outer_victim = 0

#检查是否已经修改完成
grep anoma /home/webdefender/conf/wdd.cfg

#重启引擎让配置生效
ssr


![解决内部受害者IP告警不触发问题_img1.png](../assets/解决内部受害者IP告警不触发问题/解决内部受害者IP告警不触发问题_img1.png)



![解决内部受害者IP告警不触发问题_img2.png](../assets/解决内部受害者IP告警不触发问题/解决内部受害者IP告警不触发问题_img2.png)



![解决内部受害者IP告警不触发问题_img3.png](../assets/解决内部受害者IP告警不触发问题/解决内部受害者IP告警不触发问题_img3.png)

