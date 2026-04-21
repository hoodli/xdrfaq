## 命令

```bash
kubectl get pods -A | grep -E 'Error|ContainerStatusUnknown|Completed|Terminating' | awk '{print "kubectl -n "$1" delete pods "$2" --force"}' | xargs -I {} /bin/bash -c {}
```

## 说明

- `-A`：查看所有命名空间
- `grep -E`：匹配异常状态关键词
- `--force`：强制删除（跳过graceful period）

## 注意事项

1. 生产环境慎用，可能导致业务中断
2. Completed 状态通常是正常完成的Job/CronJob，可根据实际情况调整过滤条件
3. Terminating 状态的Pod可能需要等待更长时间或手动清理底层容器

## 改进版本（仅删除Error状态）

```bash
kubectl get pods -A | grep 'Error' | awk '{print "kubectl -n "$1" delete pods "$2" --force"}' | xargs -I {} /bin/bash -c {}
```

