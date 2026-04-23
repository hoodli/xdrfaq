---
title: AXDR 许可文件不合法-机器码不一致
tags: [XDR, license, troubleshooting, reference]
created: 2026-04-23
type: permanent
summary: 许可文件报错"机器码不一致"，原因是 license 文件缺少 platformUUID 字段，需重新申请。
---

# AXDR 许可文件不合法：机器码不一致

## 报错信息

```
许可文件不合法：read machineCode from disk not eq licence
```

## 关键日志

```
read machineCode from disk not eq licence
disk:   061c5bcd-658e-4a45-b57a-3950bb75283a
license:a4cae7215f537face02a50914f06c4c9112e4a4f4d53f32285544c8e211ffea9
```

## 根本原因

许可文件中缺少 `platformUUID` 字段，导致系统从磁盘读取的机器码与 license 文件中的机器码格式/内容不一致，校验失败。

## 解决方法

1. 在 AXDR 控制台导出许可申请文件（.req 或 .lic 申请文件）
2. 将申请文件发给安恒申请新的 license
3. 将新 license 文件上传到 `/share_data/lic/default.lic`
4. 系统会自动检测文件变更并重新加载（LicenseWatcher 监听）

## 补充说明

- license 文件路径：`/share_data/lic/default.lic`
- 系统通过 `FileWatchService` 监听该文件变更，上传后自动生效，无需重启
- 如上传后仍报错，检查新 license 是否包含 `platformUUID` 字段
