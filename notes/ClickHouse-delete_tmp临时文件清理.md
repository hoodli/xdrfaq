---
title: ClickHouse delete_tmp 临时文件清理（最小侵入修复）
tags: [#ClickHouse #k8s #troubleshooting #reference]
created: 2026-04-28
type: reference
summary: ClickHouse 因残留 delete_tmp_* 临时目录导致异常时的标准修复流程，通过容器内操作最小侵入
---

# ClickHouse delete_tmp 临时文件清理（最小侵入修复）

## 问题现象

ClickHouse Pod 启动异常或运行报错，日志中提示 `delete_tmp_*` 相关错误。这是 ClickHouse 合并/删除操作产生的临时目录，异常中断后残留。

## 标准修复流程

### 第一步：找到 Pod + PVC

```bash
kubectl get pod -n <ns> -o wide
kubectl describe pod <clickhouse-pod> -n <ns>
```

确认数据路径（通常）：`/var/lib/clickhouse/`

### 第二步：进入容器 exec

```bash
kubectl exec -it <pod> -n <ns> -- bash
```

### 第三步：查找异常目录

```bash
cd /var/lib/clickhouse/store
find . -name "delete_tmp_*"
```

### 第四步：删除

```bash
rm -rf /var/lib/clickhouse/store/*/*/delete_tmp_*
```

### 第五步：重启 Pod

```bash
kubectl delete pod <pod> -n <ns>
```

> StatefulSet 会自动重建 Pod，重启后验证日志确认正常。

## 注意事项

1. **先 exec 再删除**：通过容器内操作，不依赖底层存储类型（Local Path / NFS / Ceph 均适用）
2. **delete_tmp_* 是临时目录**：ClickHouse 合并过程中产生，正常情况下会自动清理，异常中断后残留
3. **删除前确认 Pod 状态**：如果 Pod 已经 CrashLoopBackOff，直接 exec 可能失败，此时需要先考虑 scale replicas=0 后在宿主机操作
4. **重启而非强行恢复**：删除完成后用 `delete pod` 让 K8s 重建，不要在容器内手动启动 clickhouse-server

## 备选方案：宿主机直连 PV（当 exec 不可用时）

当 Pod 无法启动、exec 失败时：

1. `kubectl describe pv <pvc-name>` 找到宿主机物理路径
2. SSH 到对应节点，直接操作 PV 目录下的 store 路径
3. 清理完成后 `kubectl delete pod` 触发重建

## 参考来源

- 实际排障记录：2026-04-28 国铁项目 ClickHouse 集群
