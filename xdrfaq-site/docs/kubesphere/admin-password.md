## 重置 admin 密码

```bash
kubectl patch users <USERNAME> -p '{"spec":{"password":"<YOURPASSWORD>"}}' --type='merge' && kubectl annotate users <USERNAME> iam.kubesphere.io/password-encrypted-
```

- `<USERNAME>` 替换为用户名，通常是 `admin`
- `<YOURPASSWORD>` 替换为新密码
- 两条命令用 `&&` 串联：先 patch 密码，再删除加密标注（强制重新加密）

## 查看 ks-installer 日志（含初始密码，端口 30881）

```bash
sudo kubectl -n kubesphere-system logs `sudo kubectl get pod -n kubesphere-system | grep ks-installer- | awk -F ' ' '{print $1}'`
```

- 在 installer 日志末尾可以找到控制台地址和初始 admin 密码
- 端口默认 30881

