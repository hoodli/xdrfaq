---
title: XDR-Nacos密码修改后同步配置
tags: [#XDR #k8s #Nacos]
created: 2026-05-06
type: permanent
summary: Ailpha XDR 修改 Nacos 密码后需同步更新 midware-env ConfigMap
---

## 问题描述

在 Ailpha XDR 环境中修改 Nacos 密码后，如果只改数据库密码不做其他操作，应用 Pod 会因为 Nacos 认证失败而无法正常连接。

## 操作步骤

### 第一步：修改 ConfigMap

```bash
kubectl edit cm -n ailpha-xdr midware-env
```

在编辑器中找到 `NACOS_AUTH_IDENTITY_VALUE` 字段，将其值修改为新的 Nacos 密码。

### 第二步：重启应用 Pod

手动删除相关 Pod，触发 K8s 重新调度使新配置生效：

```bash
kubectl delete pod -n ailpha-xdr -l app=<应用标签>
# 或精确指定
kubectl delete pod -n ailpha-xdr <pod-name>
```

## 注意事项

- `NACOS_AUTH_IDENTITY_VALUE` 必须与 Nacos 实际密码保持一致，否则应用启动后会报认证错误
- 如果是集群环境，需要确认所有节点的 ConfigMap 都已同步更新
- 重启前建议确认 ConfigMap 修改已保存保存

## 相关文档

- [[XDR-AXDR1000部署命令]]
- [[k8s-服务启停]]
