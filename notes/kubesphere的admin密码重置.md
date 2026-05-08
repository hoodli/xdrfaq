---
title: kubesphere的admin密码重置
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# kubesphere的admin密码重置



## 适配版本


R25C21及以后


## 需求


admin密码修改后忘了。需要重置


## 步骤


kubectl patch users admin -p '{"spec":{"password":"P@88w0rd"}}' --type='merge' && kubectl annotate users admin iam.kubesphere.io/password-encrypted-
#示例中的P@88w0rd是重置后的密码，现场可以根据实际情况进行修改调整
#密码必须包含至少一个数字、一个小写字母、一个大写字母和一个特殊字符（~!@#$%^&*()-_=+|[{}];:'",<.>/? 或空格），长度为 8 到 64 个字符。
