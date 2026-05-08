---
title: 缺少resolv.conf文件导致安装失败
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 缺少resolv.conf文件导致安装失败



## 适用版本


R25C21


## 问题现象



## 原因


缺少resolve.conf文件


## 解决步骤


touch  /etc/resolv.conf
#然后重新执行安装命令


![缺少resolv.conf文件导致安装失败_img1.png](../assets/缺少resolv.conf文件导致安装失败/缺少resolv.conf文件导致安装失败_img1.png)

