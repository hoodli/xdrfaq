---
title: K8S手动创建apt
tags: [#k8s, #helm, #XDR]
created: 2026-04-16
type: permanent
summary: v2.0R25C40全量包部署axdr1000型号缺少apt容器时，手动通过helm安装apt并修正镜像名称大小写
---

## 适配版本

v2.0R25C40

## 现象

安装全量包部署 axdr1000 型号后，没有 apt 容器。

## 步骤

```bash
cd /etc/ansible/roles/apps/files/charts
mkdir apt-tmp
tar xf apt-v2.0r78c08-lb.tar.gz -C apt-tmp
tar xf apt-2.0.0-r78.c08.tgz -C apt-tmp
cd apt-tmp/apt
cp -a ../docker/values.json .
helm install -n ailpha-xdr apt -f values.json .
```

```bash
# 把apt image中的大写改为小写
kubectl edit deploy -n ailpha-xdr apt

# 删除pod触发重建
kubectl delete po -n ailpha-xdr <apt pod名称>

# 检查
kubectl get po -n ailpha-xdr | grep apt
```

## 注意事项

- 镜像名称必须全小写，否则拉取失败
- helm install 前确保 values.json 配置正确
