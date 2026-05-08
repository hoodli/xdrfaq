---
title: AI一体机部署(C40)
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# AI一体机部署(C40)


安装包：

http://10.50.1.141/release/AXDR/tools/ai-package/LUANBIRD-ailpha_xdr-V2.0R25C40-x86_64-2026020918.tar.gz

http://10.50.1.141/release/AXDR/tools/ai-package/aigc-patch.tar.gz

步骤说明：

1、先解压LUANBIRD-ailpha_xdr-V2.0R25C40-x86_64-2026020918.tar.gz 到/etc目录下，再执行tar -zxvf aigc-patch.tar.gz -C /etc/

2、正常安装axdr

3、修改 /etc/ansible/roles/mysql/tasks/main.yml

- name:  Register mysql info

ansible.builtin.set_fact:

svc: "{{ item }}"

when: item.name == "mysql" and item.version in ["5.7.43"]

loop: "{{ services }}"

中的 5.7.43 改成 8.4.7-standalone

4、在 /etc/ansible 目录下 执行

bash tools/retry-single-role.sh mysql

5、  执行恒脑开场

kubectl create ns aigc
kubectl get cm -n ailpha-xdr midware-env -o yaml > /tmp/midware-env.yaml
sed -i "s/ailpha-xdr/aigc/g" /tmp/midware-env.yaml
kubectl -n aigc apply -f /tmp/midware-env.yaml

6、部署恒脑
