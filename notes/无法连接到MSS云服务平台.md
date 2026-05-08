---
title: 无法连接到MSS云服务平台
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 无法连接到MSS云服务平台



## 版本


V2.0R25C01


## 报错现象


无法连接到MSS云服务平台： report-invalid character '<' looking for beginning of value


## MSS镜像


http://10.50.1.141/release/AXDR/AXDR-V2.0R23C10%e8%a1%a5%e4%b8%81%e5%8c%85/V2.0R23C10SPC008/mss-v1.0.11-202403281604.tar.gz


## 解决步骤


更换MSS新镜像

停止1-Ytagent-1容器

可以执行docker inspect 1-Ytagent-1命令， 查看docker-compose.yml位置

在宿主机/opt/ailpha-install/docker-compose目录中执行命令：

docker-compose -f docker-compose-application.yml down Ytagent

检查Ytagent容器是否已删除：ps -ef | grep Ytagent

上传镜像到宿主机/home/mss目录中，镜像为：mss-v1.0.11-202403281604.tar.gz

在宿主机/home/mss目录下，执行命令：

docker load -i mss-v1.0.11-202403281604.tar.gz

在宿主机/opt/ailpha-install/docker-compose/目录下，

查看docker-compose-application.yml文件云通相关配置是否正确，若不正确需修改。

vi docker-compose-application.yml

修改image值为：docker.das-security.cn/luanniao/mss:v1.0.11

在宿主机/opt/ailpha-install/docker-compose/目录下，执行命令：

1. docker-compose -f docker-compose-application.yml up -d Ytagent

检查1-Ytagent-1容器是否正常启动，如下图所示则为正常启动：

docker ps | grep 1-Ytagent-1

进入云通容器，查看镜像是否替换成功：ueproxy、uemanager有进程，ytagent无进程

docker exec -ti 1-Ytagent-1 bash
ps -ef | grep ueproxy
ps -ef |grep uemanager

ps -ef |grep ytagent


![无法连接到MSS云服务平台_img1.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img1.png)



![无法连接到MSS云服务平台_img2.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img2.png)



![无法连接到MSS云服务平台_img3.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img3.png)



![无法连接到MSS云服务平台_img4.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img4.png)



![无法连接到MSS云服务平台_img5.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img5.png)



![无法连接到MSS云服务平台_img6.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img6.png)



![无法连接到MSS云服务平台_img7.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img7.png)



![无法连接到MSS云服务平台_img8.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img8.png)



![无法连接到MSS云服务平台_img9.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img9.png)



![无法连接到MSS云服务平台_img10.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img10.png)



![无法连接到MSS云服务平台_img11.png](../assets/无法连接到MSS云服务平台/无法连接到MSS云服务平台_img11.png)

