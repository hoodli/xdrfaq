---
title: XDR 信息汇总
tags: [XDR, reference]
created: 2026-04-22
type: permanent
summary: 记录 XDR 产品相关的零散信息、版本变更、注意事项等。
---

# XDR 信息汇总

## 版本变更

| 版本 | 变更内容 |
|------|----------|
| v2.0R26C10 | 界面美化许可码已移除，无需再配置 |

## 安恒防火墙

- 域名封禁：已操作过，可在安恒防火墙上配置域名级别的封禁策略

## 龙虾模型数据查询

现场查询是否满足龙虾模型检测数据条件：

- **终端日志**：`hostAddress exist AND logType in ["alert","file","process"] AND deviceSendProductName == "明御终端安全及管理系统"`
- **流量日志**：`appProtocol in ["websocket","http"] AND deviceSendProductName == "安恒全流量深度威胁检测系统"`

