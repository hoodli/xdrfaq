# 部署1690 saas-web持续更新中修复

## 问题现象

部署 1690 后，saas-web 容器状态一直是"更新中"，无法正常运行。

## 错误日志

```
### Cause: org.postgresql.util.PSQLException: ERROR: relation "i18n_dict" does not exist
```

## 根因

这是已知 bug，ailpha 缺少 `i18n_dict` 表。

## 解决办法

在升级管理 → **解析引擎** 菜单下升级 ailog 包即可修复。

## 升级包

| 项目 | 内容 |
|------|------|
| 包名 | ailpha-ailog-v1.9-xsiam-962e13e_962e13e-2604151751.zip |
| 百度盘链接 | https://pan.baidu.com/s/1au1q6fCGtPppUL6Gvccvww |
| 提取码 | 6ebw |

