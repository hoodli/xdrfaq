---
title: 从底座修改磁盘使用上限 k8s
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 从底座修改磁盘使用上限-k8s



## 适配版本


v2.0r25c40


## 步骤


vim /var/lib/kubelet/config.yaml
#最后面增加配置，10%，对应90%最大磁盘占用
evictionHard:
  nodefs.available: "10%"
  nodefs.inodesFree: "5%"

systemctl restart kubelet
