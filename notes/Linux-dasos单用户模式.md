---
title: Linux-dasos进入单用户模式
tags: [#Linux #XDR #reference]
created: 2026-05-06
type: permanent
summary: dasos系统进入单用户模式修改root密码的操作步骤与注意事项
---

# dasos 进入单用户模式

## 适配系统
dasos 系统

## 操作步骤

### 1. 修改引导参数
重启系统后，根据引导界面下方提示按下 `e` 或 `Tab` 键，编辑需要修改的内核对应的引导项。

### 2. 添加启动参数
使用上下键移动光标到 `linux` 开头的行，行尾空格添加 `init=/bin/bash` 或 `init=/bin/sh`，按下 `Ctrl + x` 组合键进入系统。

### 3. 注意事项 ⚠️

| 序号 | 说明 |
|------|------|
| a | 若进入编辑页面要求 **输入用户名密码**（无要求则跳过）：用户名 `root`，密码 `openFuler#12` |
| b | 添加上述配置后若出现**无法进入环境**的情况，查看 linux 所在行 **console** 参数，根据实际启动环境时的输出进行配置（**串口输出**：vga=输出） |
| c | 若当前使用 **vga 输出**，则**移除** `console=xxxx,115200n8` 的配置 |
| d | 若当前使用**串口输出**，则**移除不包含** `console=xxxx,115200n8` 的配置 |
| e | xxxx 包括但不限于 `ttyS0`、`ttyAMA0`、`ttyAMA1` 等，即**确保有且仅有一组 console 参数且匹配当前的输出模式**；以上 **修改的引导项参数都是临时生效** |

### 4. 成功进入系统后执行命令

```bash
mount -o remount, rw /    # 重新挂载 / 为可读写模式
passwd root               # 根据提示修改密码
touch /.autorelabel       # （若之前系统内启用了 selinux，则运行此命令）
exec /sbin/init           # 正常启动系统 或 exec /sbin/reboot 重启系统复制制错误已修复
```

### 5. 验证
修改成功后，可使用上述操作所修改的密码进行 root 登录。
