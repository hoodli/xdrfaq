# 笔记索引

## Linux

- [[Linux-AXDR快速部署脚本]] — AXDR 节点 IP 变更快速部署脚本，支持一键修改 hosts、网卡 IP 并执行集群迁移
- [[Linux-dasos单用户模式]] — dasos 系统进入单用户模式修改 root 密码的操作步骤与注意事项
- [[k8s-PG连接异常处理]] — PostgreSQL连接异常时启用failsafe_mode的应急处理流程
- [[k8s-服务启停]] — 批量关闭/启动K8s所有节点服务（kubelet、containerd、所有容器）
- [[k8s-清理异常状态Pod]] — 批量清理Kubernetes中处于Error、ContainerStatusUnknown、Completed、Terminating状态的Pod
- [[测试环境账号信息]] — 测试环境服务器 10.50.3.9 登录信息

## KubeSphere

- [[kubesphere-admin密码管理]] — KubeSphere 重置和查看 admin 密码的 kubectl 命令
- [[k8s-手动创建apt]] — v2.0R25C40全量包部署axdr1000缺少apt容器时的手动helm安装步骤

## XDR

- [[XDR-AXDR1000部署命令]] — AXDR1000 集群初始化与部署的标准命令序列
- [[XDR-AXDR一体机运维速查]] — AXDR 一体机日常运维命令、默认密码、日志路径、故障处理速查
- [[X86系统镜像下载]] — DAS-OS M2.1.2 x86_64 系统镜像百度网盘下载链接
- [[XDR-V2R25C40-x86全量包升级包下载]] — AXDR V2.0R25C40 x86 全量包及升级包百度网盘下载链接
- [[XDR-部署1690-saas-web更新中修复]] — 部署1690 saas-web持续"更新中"，i18n_dict 表缺失导致，需升级 ailog 解析引擎
- [[XDR-Nacos密码修改后同步配置]] — 修改 Nacos 密码后需同步更新 midware-env ConfigMap 中的 NACOS_AUTH_IDENTITY_VALUE
