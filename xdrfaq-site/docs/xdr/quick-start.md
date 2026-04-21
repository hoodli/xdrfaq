# AXDR 快速部署脚本 quick_start.sh

> 脚本路径：`/etc/ansible/hosts` 同目录
> 使用方式：`bash 脚本名称 <新IP>`
> 适用版本：AXDR V2.0R25C40

## 功能概述

该脚本在节点 IP 变更场景下，一键完成以下三步操作：

1. **修改 Ansible hosts 文件** — 替换 `hostname=master1` 行中的旧 IP 为新 IP
2. **修改网卡 IP** — 通过 `nmcli` 永久更新对应网卡的 IPv4 地址
3. **执行集群迁移** — 运行 `tools/lbctl cluster move do`

## 使用方法

```bash
bash quick_start.sh <新IP>
```

## 前提条件

- 脚本必须在目标节点上以 root 权限运行
- 需要以下命令可用：`sed`、`awk`、`ip`、`nmcli`
- `/etc/ansible/hosts` 必须存在且包含 `hostname=master1` 行
- `/etc/ansible/tools/lbctl` 必须存在且可执行

## 执行步骤详解

### Step 1：更新 Ansible hosts 文件

从 `/etc/ansible/hosts` 中找到包含 `hostname=master1` 的行，提取其第一个字段（旧 IP），替换为新 IP。

```bash
# 示例：如果旧 IP 为 10.10.10.11，新 IP 为 10.10.10.22
# 替换 hosts 文件中对应行的 IP
```

### Step 2：更新网卡 IP（nmcli）

脚本自动完成以下操作：

1. 通过 `ip -o -4 addr show` 找到当前持有旧 IP 的网卡设备
2. 查询该网卡对应的 NetworkManager 连接名称（conn）
3. 获取网段的 prefix 长度（如 /24）
4. 获取默认网关
5. 通过 `nmcli con mod` 永久修改 IP 地址
6. 同步更新 `kube-apiserver.yaml` 中的 IP

```bash
nmcli con mod "$conn" ipv4.method manual
nmcli con mod "$conn" ipv4.addresses "${new_ip}/${prefix}"
nmcli con mod "$conn" ipv4.gateway "$gw"
```

### Step 3：执行集群迁移

```bash
cd /etc/ansible && tools/lbctl cluster move do
```

## IP 格式校验

脚本内建 IPv4 格式校验，每个八位组必须在 0-255 范围内。

## 注意事项

- **幂等性**：如果新 IP 与旧 IP 相同，Step 1 会跳过，但 Step 2 和 Step 3 仍会执行
- **备份**：修改 `/etc/ansible/hosts` 前会自动生成 `.bak` 备份
- **网络连通性**：确保新 IP 在同一网段且网关可达，否则集群通信可能中断
- **多节点场景**：每个节点需要分别执行脚本

