---
title: AXDR saas-upgrade Pod 重建
tags: [XDR, k8s, reference]
created: 2026-04-22
type: permanent
summary: 通过 helm upgrade 从本地 chart 包重建 saas-upgrade Pod，适用于 saas-upgrade pod 异常或需要重新初始化ailpha-xdr 组件的场景。
---

# AXDR saas-upgrade Pod 重建

## 场景

saas-upgrade pod 处于异常状态（如 CrashLoopBackOff、Completed 等），或 ailpha-xdr 组件初始化/重置时需要重建。

## 前置准备

确认以下文件存在于 `cd /etc/ansible/roles/apps/files/charts/` 目录：

- `saas-upgrade-5.1.0-xsiam.tgz`
- `saas-upgrade-v5.1.0-xsiam-lb.tar.gz`
- `../docker/values.json`（helm values 文件）

## 重建步骤

### 1. 解压 Chart 包

```bash
cd /etc/ansible/roles/apps/files/charts/
mkdir -pv saas-upgrade
tar xf saas-upgrade-5.1.0-xsiam.tgz -C saas-upgrade
tar xf saas-upgrade-v5.1.0-xsiam-lb.tar.gz -C saas-upgrade
```

### 2. 进入 Chart 目录

```bash
cd saas-upgrade/saas-upgrade/
ls
```

确认目录下存在 `Chart.yaml` 和 `values.yaml` 等文件。

### 3. 确认当前 release 状态（可选）

```bash
helm list -n ailpha-xdr
```

查看 saas-upgrade 当前状态。

### 4. 执行 helm upgrade 安装/重建

```bash
helm upgrade --install -n ailpha-xdr saas-upgrade . -f ../docker/values.json
```

> `--install` 表示如果 release 不存在则创建，存在则升级。
> `-f ../docker/values.json` 指定 values 配置文件。

### 5. 验证 Pod 状态

```bash
kubectl get pods -n ailpha-xdr | grep saas-upgrade
```

### 6. 查看重建日志

```bash
kubectl logs -f -n ailpha-xdr saas-upgrade-<随机后缀>
```

Pod 名称后缀由 ReplicaSet 自动生成，可从 `kubectl get pods` 输出中获取。

## 快速一键执行

```bash
cd /etc/ansible/roles/apps/files/charts/ && \
mkdir -pv saas-upgrade && \
tar xf saas-upgrade-5.1.0-xsiam.tgz -C saas-upgrade && \
tar xf saas-upgrade-v5.1.0-xsiam-lb.tar.gz -C saas-upgrade && \
helm upgrade --install -n ailpha-xdr saas-upgrade saas-upgrade/saas-upgrade -f ../docker/values.json && \
kubectl get pods -n ailpha-xdr | grep saas-upgrade && \
kubectl logs -f -n ailpha-xdr saas-upgrade-$(kubectl get pods -n ailpha-xdr -o jsonpath='{.items[?(@.spec.containers[0].name=="saas-upgrade")].metadata.name}')
```

## 注意事项

- saas-upgrade 通常是初始化任务型 Job，Completed 状态属于正常完成态
- 如果需要重置 ailpha-xdr 组件，先删除已有 release：`helm uninstall -n ailpha-xdr saas-upgrade`
- values.json 包含 ailpha-xdr 命名空间下各组件的镜像、配置信息，重建前确认路径正确
