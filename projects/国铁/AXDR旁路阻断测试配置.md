---
title: AXDR旁路阻断测试配置
tags: [XDR, AXDR, 项目-国铁, 旁路阻断, 配置]
created: 2026-04-14
type: permanent
summary: 国铁项目中 AXDR 旁路阻断功能的配置步骤，包括配置MAC地址和不配置MAC地址两种方式。
---

# AXDR旁路阻断测试配置

> 文档来源：`国铁项目旁路阻断测试配置-20260225.docx`
> 日期：2026-02-25

## 网络拓扑

| 角色 | IP |
|------|----|
| 客户端 | 10.10.11.12 |
| 被阻断服务器 | 10.10.10.22 |
| 阻断口 | 10.10.11.20 |

---

## 前置步骤：确认阻断口信息

1. SSH 登录 XDR 服务器
2. 查看阻断口的网卡名称和对应的网关 MAC 地址
3. 执行 `arp -n` 获取网关 MAC 地址

---

## 方式一：配置 MAC 地址

### 步骤 1：确认网卡信息

- `enp125s0f1` — 阻断口网卡名称
- `70:3a:a6:17:30:f6` — 阻断口对应的网关 MAC 地址

> ⚠️ **特别说明**：确保阻断口和服务器客户端联通。

### 步骤 2：进入 APT 容器

```bash
kubectl exec -it `kubectl get pod -n ailpha-xdr | grep apt | awk -F ' ' '{print $1}'` -n ailpha-xdr /bin/bash
```

> ⚠️ **注意**：联系产线远程协助登录 MySQL。

### 步骤 3：更新数据库配置

```sql
update wdd_sysconfig set val='enp125s0f1' where item = 'gsc_block_nic';
update wdd_sysconfig set val='70:3a:a6:17:30:f6' where item = 'gsc_block_mac';
update wdd_sysconfig set val='1' where item = 'gsc_send_packet_mode';
```

### 步骤 4：修改 VPP 配置

在 `/data/vpp/vppids/config` 目录下：

```bash
mv start.conf start_high.conf
```

编辑 `start.setup` 文件，将 `enp125s0f1`（业务口网卡名称）的 `num-tx-queues` 后面的数字由 `0` 改为 `3`。

### 步骤 5：重启 APT 业务

执行重启命令使配置生效。

### 步骤 6：配置 APT 平台策略

1. 客户端用浏览器访问 `http://10.10.10.22/`，确认 Web 界面正常
2. 登录 APT 平台，进入 **【配置 / 联动阻断 / 旁路阻断】** 页面
3. 新增策略并按现场实际情况填写内容
4. 策略新增成功后手动启用策略（弹框中点击 **<确定>**）

### 验证

- **不启用策略**：客户端访问 `http://10.10.10.22/`，Web 界面正常
- **启用策略后**：客户端访问 `http://10.10.10.22/`，Web 界面无法正常访问

---

## 方式二：不配置 MAC 地址

> ⚠️ **特别说明**：确保阻断口是 **trunk 模式**，输出流量带上 **vlan 标签**。

### 步骤 1：进入 APT 容器

同上。

### 步骤 2：删除 MAC 地址配置

```sql
update wdd_sysconfig set val='' where item = 'gsc_block_mac';
```

### 步骤 3：重启 APT 业务

### 步骤 4：配置 APT 平台策略（同方式一）

### 验证

- **禁用策略**：客户端访问正常
- **启用策略**：客户端访问被阻断
