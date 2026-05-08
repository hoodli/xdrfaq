### 重置kubesphere的admin密码
`kubectl patch users <USERNAME> -p '{"spec":{"password":"<YOURPASSWORD>"}}' --type='merge' && kubectl annotate users <USERNAME> iam.kubesphere.io/password-encrypted-`

### 查看kubesphere的admin密码(30881)
```sudo kubectl -n kubesphere-system logs `sudo kubectl get pod -n kubesphere-system | grep ks-installer- | awk -F ' ' '{print $1}'```

