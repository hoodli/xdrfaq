---
title: K8s PG连接异常处理
tags: [#k8s, #PostgreSQL]
created: 2026-04-27
type: permanent
summary: PostgreSQL连接异常时启用failsafe_mode的应急处理流程
---

# K8s PG连接异常处理

## 处理流程

### 1. 查看 PG Pod 状态

```bash
kubectl get pods -n postgresql
```

### 2. 判断条件

如果 `READY` 字段显示为 `1/1`，说明 Pod 本身正常，但可能存在连接异常，继续执行以下步骤。

### 3. 编辑 PostgreSQL 集群配置

```bash
kubectl -n postgresql edit postgresqls.acid.zalan.do postgresql-cluster
```

### 4. 添加 failsafe_mode

找到第19行左右的 `patroni:` 配置项，在其下方新增：

```yaml
patroni:
  failsafe_mode: true
```

### 5. 重启 PG Pod 使配置生效

修改配置后如 PG 未自动重启，执行以下命令手动重启：

```bash
kubectl delete pod postgresql-cluster-0 -n postgresql
```

## 说明

- `failsafe_mode: true` 是 Patroni 的故障安全模式，用于处理集群连接异常场景
- 修改后 Patroni 会自动重新加载配置，无需手动重启 Pod
- 如问题仍未解决，需进一步检查网络连通性和 PG 日志
