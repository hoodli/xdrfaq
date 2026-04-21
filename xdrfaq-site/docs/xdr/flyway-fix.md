# XDR 数据库迁移失败修复

## 故障现象

初始安装后，xdr、patrol、mirror 服务启动失败，日志中均有 Flyway 报错：

```
Caused by: org.flywaydb.core.api.FlywayException: Schema `patrol` contains a failed migration to version 20191205194200 !
```

## 根因

Flyway 启动时校验数据库迁移版本表，某条迁移记录的 `success=0`（失败状态），导致校验不通过，服务无法启动。

涉及三个数据库及其对应的 schema 表：

| 数据库 | Schema 表 |
|--------|-----------|
| patrol | patrol_flyway_schema |
| xdr | xdr_schema_version |
| bigdata-web | schema_version |

## 修复步骤

### 1. 获取 MySQL 密码

```bash
kubectl get pods -n ailpha-xdr | grep ^mirror- | awk '{print $1}' \
  | xargs -I {} kubectl exec -n ailpha-xdr {} -- env | grep MYSQL_SERVICE_PASSWORD
```

输出示例：
```
MYSQL_SERVICE_PASSWORD=2ckqaLXh6Aqx2aRF
```

### 2. 进入 MySQL Pod

```bash
kubectl exec -ti -n mysql mysql-primary-0 -- bash
```

### 3. 连接数据库

```bash
mysql -udbapp -p'密码'
```

### 4. 修复三个库的 schema 表

```sql
-- 修复 patrol 库
USE patrol;
UPDATE patrol_flyway_schema SET success = 1 WHERE success = 0;

-- 修复 xdr 库
USE xdr;
UPDATE xdr_schema_version SET success = 1 WHERE success = 0;

-- 修复 bigdata-web 库
USE bigdata-web;
UPDATE schema_version SET success = 1 WHERE success = 0;
```

### 5. 验证

退出 MySQL，等待 pod 自动重启恢复：

```bash
kubectl get pods -n ailpha-xdr -w
```

## 注意事项

- MySQL 用户为 `dbapp`，密码从 mirror pod 环境变量获取
- 操作前建议先 `SELECT * FROM 表名 WHERE success = 0;` 确认受影响行数
- 三个库都要改，缺一不可
- 修复后无需手动重启 pod，Kubernetes 会自动重试

