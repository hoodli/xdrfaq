---
title: Redis 文件损坏问题解决步骤
tags: [Redis, XDR, k8s, troubleshooting]
created: 2026-04-22
type: permanent
summary: Redis 节点 appendonly.aof 文件损坏时的诊断与修复流程，通过删除损坏文件并重建 Pod 恢复服务。
---

# Redis 文件损坏问题解决步骤

## 场景

Redis Pod 异常，怀疑 AOF（Append Only File）文件损坏导致服务不可用。

## 诊断步骤

### 1. 查看 Pod 状态

```bash
kubectl describe pod -n redis redis-node-0
```

### 2. 查看 PVC 配置

```bash
kubectl get pvc -n redis redis-data-redis-node-0 -o yaml
```

获取 PVC 名称，用于追溯底层 PV。

### 3. 查看 PV 信息

```bash
kubectl get pv pvc-b3cf7c6e-c937-4336-83ab-9ffd00220b55 -o yaml
```

确认 PV 绑定状态及存储路径。

## 修复步骤

### 1. 定位 AOF 文件目录

```bash
cd /data/local_path/k8s_data/pvc-b3cf7c6e-c937-4336-83ab-9ffd00220b55_redis_redis-data-redis-node-0/appendonlydir/
```

路径格式：`/data/local_path/k8s_data/pvc-<uuid>_<namespace>_<pvc-name>/appendonlydir/`

### 2. 备份损坏文件

```bash
mv appendonly.aof.2.incr.aof appendonly.aof.2.incr.aof-bak
mv appendonly.aof.manifest appendonly.aof.manifest-bak
```

保留原文件以便排查。

### 3. 重建 Pod

```bash
kubectl delete pod -n redis redis-node-0
```

Pod 删除后，StatefulSet 会自动拉起新 Pod，Redis 会重新生成 AOF 文件。

## 验证

重建后检查 Pod 是否 Running：

```bash
kubectl get pods -n redis
```

确认 Pod 进入 Running 状态后，验证 Redis 服务：

```bash
kubectl exec -it -n redis redis-node-0 -- redis-cli ping
```

## 注意事项

- 删除 Pod 前务必先备份损坏文件
- AOF 文件损坏通常因异常断电或磁盘 I/O 故障导致
- appendonlydir 目录路径需根据实际 PVC 挂载情况调整，可通过 `kubectl describe pod` 或 PV 信息确认
- 如果节点上有多份 .aof 文件，Redis 启动时会自动选择可用的文件继续恢复