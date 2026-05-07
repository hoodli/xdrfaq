---
title: AXDR 一体机运维速查
tags: [#XDR, #k8s, #Linux, #reference]
created: 2026-04-14
type: permanent
summary: AXDR 一体机日常运维命令、默认密码、日志路径、故障处理速查
---

> ⚠️ 本笔记包含敏感凭据，妥善保管。

## 默认密码（老版本 / 新运维底座）

| 组件 | 老版本 | 新运维底座 |
|------|--------|------------|
| ambari | bTxUv7rGU* | ambari |
| kibana | unFx7%EbR3 | kibana |
| ailpha | F@Jhq5GyW7 | F@Jhq5GyW7 |
| useradmin | iS%4Rh37g3 | useradmin |

ambari 密码文件：
```bash
cat /etc/ansible/cluster_init/conf/console-passwd.json
```

## 日志路径

| 服务 | 容器 | 路径 |
|------|------|------|
| mirror-web-api | 1-Mirror-1 | /usr/hdp/2.5.3.0-37/bigdata/mirror-web-api/logs/main.log |
| kafka | 1-Kafka-1 | /opt/kafka/logs/server.log |
| Ambari-server | ambari-server | /var/log/ambari-server/ambari-server.log |
| Ambari-agent | 各容器 | /var/log/ambari-agent/ambari-agent.log |
| Elasticsearch | 1-Elasticsearch-1 | /usr/share/elasticsearch/logs/es-cluster.log |
| Baas | 1-Baas-1 | /usr/hdp/2.5.3.0-37/baas/baasweb/logs/main.log |

容器日志：
```bash
docker logs -f --tail=100 1-XX-1
```

## 命令汇总

### 1. 查看 ambari/kibana/Yarn/Nacos/Devops 密码
```bash
cat /etc/ansible/cluster_init/conf/console-passwd.json
```

### 2. 消费 kafka topic
```bash
docker run --rm --net mynet ailpha-registry:5000/kafka:2.10-0.10.2.2 \
  /opt/kafka/bin/kafka-console-consumer.sh \
  --zookeeper 1-Zookeeper-1 \
  --topic com.dbapp.topic.devicealarm
```

### 3. 查找僵尸进程
```bash
ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]'
```

### 4. 安全事件延迟重置 groupid
- 登录 nacos：`http://192.168.30.73:8848/nacos`，账号 nacos/nacos
- 修改配置项：`security_event_group_id`
- 重启 xdr 拓展程序

### 5. 修改 xdr 程序内存
```bash
docker exec -it 1-Xdr-1 bash
cd /usr/hdp/2.5.3.0-37/bigdata/ailpha-ext/xdr
vi conf/java_opts.conf  # 修改内存配置

# 同步更新容器限制
docker update -m 3g 1-Xdr-1
```

### 6. ES 索引只读（故障处理）
```bash
PUT */_settings
{
  "index": {
    "blocks": {
      "read_only_allow_delete": "false"
    }
  }
}
```

### 7. 一体机 ES 集群状态异常（单节点）
```bash
PUT /_settings
{
  "index": {
    "number_of_replicas": "0"
  }
}
```
> 单节点 ES 无法同时存在主分片和副本，副本设为 0。

### 8. 更新容器内存限制
```bash
docker update --memory 3G --memory-swap 3G 1-XXX-1
```

### 9. 重启 AiNTA java 服务
```bash
/home/nta/java/bin/mirror-cli.sh restart
```

### 10. 卸载 AXDR
```bash
cd /etc/ansible/ && tools/lbctl cluster uninstall
```

### 11. 重装 AXDR
```bash
cd /etc/ansible && tools/lbctl cluster deploy
```

### 12. 进入 mirror 容器
```bash
kubectl exec -it -n ailpha-xdr mirror-<pod-name> bash
```

### 13. KubeSphere admin 密码
```bash
kubectl patch users admin \
  -p '{"spec":{"password":"<NEWPASS>"}}' \
  --type='merge' \
  && kubectl annotate users admin iam.kubesphere.io/password-encrypted-

# 查看 ks-installer 日志（端口 30881）
kubectl -n kubesphere-system logs \
  $(kubectl get pod -n kubesphere-system | grep ks-installer- | awk '{print $1}')
```

### 14. xdr 告警列表归档
```bash
curl -k "https://127.0.0.1:8901/api/v1.0/mergeAlarm/archive?begin=2025-08-13&end=2025-08-14"
```

### 15. 更新 Baas 运行状态
```bash
docker exec -ti 1-Mysql-1 bash
mysql -uroot -p'<PASSWORD>' -P22

update t_bs_extension_info set status='running', result='运行中', is_success=1
  where code='baas';
```

### 16. das-os ISO 镜像
链接: https://pan.baidu.com/s/1G9Dk9NFEZUG83ESpZX1cUQ
提取码: vuc5

### 17. 索引 aliases
```bash
POST _aliases
{
  "actions": [
    {
      "add": {
        "index": "ailpha-baas-log-20250111-000001",
        "alias": "ailpha-securitylog-log-20250111"
      }
    }
  ]
}
```

### 18. 恒脑对接配置
**试用租户（XDR 对接）：**
- 访问地址：https://gc.das-ai.com
- 租户：XDR对接
- 用户名：XDR试用客户
- 用户账号：13488791581
- 密码：4wMdA7M@@5@&3Lw
- appKey：hengnaoyKGtPWiq4TFtinjeX3CD
- appSecret：mv6wx7e25prj8ur9qm1za64w3hxpfz0k
- userAppKey：hengnaoUK_YMMqBB4nubhFmE1XzQm7
- 开放服务接口：https://www.das-ai.com
- 小恒插件集成：https://www.das-ai.com/dasChat

> 正式客户租户需联系恒脑（毛天慧）申请；试用流量用完也找毛天慧充值。

### 19. 机械盘建第二个 LVM 报 device excluded by a filter
dasos 固态装系统、机械盘做数据盘，创建第二个 LVM 时报错：
```
device /dev/sdb excluded by a filter
```
原因：磁盘上残留旧分区签名/文件系统元数据，LVM filter 会排除。
解决：
```bash
wipefs -a /dev/sdb
```
清除后重新执行 pvcreate/lvcreate 即可。

## 相关笔记

- [[kubesphere-admin密码管理]] — KubeSphere admin 密码重置与查看
