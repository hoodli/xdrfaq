---
title: XDR 数据库迁移失败修复（xdr_schema_version）
tags: [#XDR, #MySQL, #k8s, #reference]
created: 2026-04-15
type: permanent
summary: xdr pod CrashLoopBackOff，原因是数据库迁移版本标记失败，通过手动更新 xdr_schema_version 表修复。
---

# XDR 数据库迁移失败修复

## 故障现象

- `xdr` pod 处于 `CrashLoopBackOff` 状态，重启次数达 195+
- `patrol` pod 处于 `Running` 但持续重启（196 次）
- 报错日志：`Validate failed: Detected failed migration to version 20211215104500`

## 根因

XDR 启动时会校验数据库迁移版本表 `xdr_schema_version`，某条迁移记录的 `success` 字段为 `0`（失败状态），导致校验不通过，pod 无法正常启动。

## 处理步骤

### 1. 获取 MySQL 密码

```bash
kubectl get pods -n ailpha-xdr | grep ^mirror- | awk '{print $1}' \
  | xargs -I {} kubectl exec -n ailpha-xdr {} -- env | grep MYSQL_SERVICE_PASSWORD
```

输出：
```
MYSQL_SERVICE_PASSWORD=2ckqaLXh6Aqx2aRF
```

### 2. 进入 MySQL Pod

```bash
kubectl exec -ti -n mysql mysql-primary-0 bash
```

### 3. 连接数据库并修复

```sql
mysql -udbapp -p'2ckqaLXh6Aqx2aRF'

USE xdr;

-- 查看失败的迁移记录（可选，用于确认）
SELECT * FROM xdr_schema_version WHERE success = 0;

-- 将失败记录标记为成功
UPDATE xdr_schema_version SET success = 1 WHERE success = 0;
-- 结果：Query OK, 1 row affected
```

### 4. 验证修复

退出 MySQL 后，等待 xdr pod 自动重启并恢复 Running 状态：

```bash
kubectl get pods -n ailpha-xdr -w
```

## 集群状态（故障时）

| Pod | 状态 | 备注 |
|-----|------|------|
| xdr-dff986b8d-t92hm | CrashLoopBackOff | 主故障 pod |
| patrol-77954888d4-skpdt | Running（频繁重启） | 关联影响 |
| 其余 pod | Running | 正常 |

## 注意事项

- MySQL 用户为 `dbapp`，密码从 mirror pod 环境变量获取
- 操作前建议先 `SELECT` 确认受影响行数，避免误改
- 修复后无需手动重启 pod，Kubernetes 会自动重试
