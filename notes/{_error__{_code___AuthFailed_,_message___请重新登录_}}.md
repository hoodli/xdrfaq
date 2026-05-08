---
title: { error  { code   AuthFailed , message   请重新登录 }}
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# {"error":{"code":"AuthFailed","message":"请重新登录"}}



## 适用版本


v2.0R25C22


## 问题现象


安装部署成功/重启后，页面管理口访问XDR平台提示：{"error":{"code":"AuthFailed","message":"请重新登录"}}


## 原因


是系统 dbus 服务异常导致 NetworkManager 退出引起的，nmstate 启动又强依赖系统的这个服务


## 解决方案


用下面几个命令处理

systemctl status dbus
systemctl status NetworkManager

如果不是 Running 状态，重启一下：

systemctl restart dbus
systemctl restart NetworkManager
kubectl rollout restart ds -n nmstate nmstate-handler


![{_error__{_code___AuthFailed_,_message___请重新登录_}}_img1.png](../assets/{_error__{_code___AuthFailed_,_message___请重新登录_}}/{_error__{_code___AuthFailed_,_message___请重新登录_}}_img1.png)

