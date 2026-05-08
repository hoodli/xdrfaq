---
title: 一键更新设备IP&IP迁移
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 一键更新设备IP&IP迁移


请至钉钉文档查看附件《quick_start.sh》。


## 需求


新设备上架，要完成

修改服务器IP

xdr程序IP迁移

通过这个脚本一次性解决。 减少人工操作步骤


## 步骤


#将脚本放在 /etc/ansible/tools目录
cd /etc/ansible/tools
bash quick_start.sh 10.20.183.159 10.20.183.1
#10.20.183.159是设备即将配置的新IP
#10.20.183.1 是网关
