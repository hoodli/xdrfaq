---
title: Claw 模型检测条件验证
tags: [XDR, Claw, detection, reference]
created: 2026-04-22
type: permanent
summary: 验证现场数据是否满足 Claw 模型检测的前置条件，包括 EDR 配置、终端日志、流量日志要求。
---

# Claw 模型检测条件验证

## 1. EDR 配置

EDR（明御终端安全管理系统）需开启相关监控模块，确保终端日志可正常上报。

**配置截图：** ![EDR配置](https://i.ibb.co/zH7zBjYb/EDR.png)

> 图片来源：https://ibb.co/zH7zBjYb

## 2. 现场数据要求

### 终端日志查询条件

```
hostAddress exist AND logType in ["alert","file","process"] AND deviceSendProductName == "明御终端安全及管理系统"
```

### 流量日志查询条件

```
appProtocol in ["websocket","http"] AND deviceSendProductName == "安恒全流量深度威胁检测系统"
```

**注：** 两个数据源都需有数据返回才算满足条件。

## 3. 原始日志要求

原始日志中 `commandLine` 字段需包含 `claw` 关键字，用于模型检测匹配。

## 验证步骤

1. 确认 EDA 配置已开启并生效（见上图）
2. 使用上述查询条件在 XDR 控制台验证终端日志有数据
3. 验证流量日志有数据
4. 检查原始日志中 commandLine 包含 "claw"

全部满足即为 Claw 模型检测就绪。