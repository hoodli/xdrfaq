---
title: 修改xdr拓展程序的内存 R25c10
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# 修改xdr拓展程序的内存-R25c10



## 适配版本


V2.0R25C10


## 现象



## 步骤


查看xdr容器内存使用情况

调整Xdr容器的内存

cd /opt/ailpha-install/docker-compose/
vi docker-compose-application.yml
#并将内存 2G 改成 4G

docker-compose  -f docker-compose-application.yml down Xdr
docker-compose  -f docker-compose-application.yml up -d Xdr

修改后的内存


![修改xdr拓展程序的内存-R25c10_img1.png](../assets/修改xdr拓展程序的内存-R25c10/修改xdr拓展程序的内存-R25c10_img1.png)



![修改xdr拓展程序的内存-R25c10_img2.png](../assets/修改xdr拓展程序的内存-R25c10/修改xdr拓展程序的内存-R25c10_img2.png)



![修改xdr拓展程序的内存-R25c10_img3.png](../assets/修改xdr拓展程序的内存-R25c10/修改xdr拓展程序的内存-R25c10_img3.png)



![修改xdr拓展程序的内存-R25c10_img4.png](../assets/修改xdr拓展程序的内存-R25c10/修改xdr拓展程序的内存-R25c10_img4.png)

