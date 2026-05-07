---
title: K8s服务批量启停
tags: [#Linux, #k8s]
created: 2026-04-27
type: permanent
summary: 批量关闭/启动K8s所有节点服务（kubelet、containerd、所有容器）
---

# K8s服务批量启停

## 关闭所有服务

```bash
# 1. 停止 kubelet
systemctl stop kubelet

# 2. 停止所有运行中的容器
nerdctl -n k8s.io ps -aq | xargs -I {} nerdctl -n k8s.io stop {}

# 3. 停止 containerd
systemctl stop containerd
```

> 顺序：kubelet → 容器 → containerd。先停 kubelet 阻止调度，再停容器，最后停容器运行时。

## 开启所有服务

```bash
# 1. 启动 containerd
systemctl start containerd

# 2. 启动所有容器（--all 包括已停止的容器）
nerdctl -n k8s.io ps -aq --all | xargs -I {} nerdctl -n k8s.io start {}

# 3. 启动 kubelet
systemctl start kubelet
```

> 顺序：containerd → 容器 → kubelet。先启动容器运行时，再恢复容器，最后启动 kubelet 恢复调度。

## 场景说明

- **关闭服务**：系统维护、内核升级、节点下线前
- **开启服务**：节点重启后、批量恢复集群
- `nerdctl -n k8s.io` 指定的是 k8s.io 命名空间，默认 `nerdctl` 操作 default 命名空间
