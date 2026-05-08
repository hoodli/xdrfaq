---
title: xdr升级超时后台升级步骤 k8s
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# xdr升级超时后台升级步骤-k8s



## 版本


R25C22/R25C21


## 步骤



### 将mirror升级包传到宿主机后台



### 将mirror升级包传到mirror容器



#### 查询mirror容器组id


kubectl -n ailpha-xdr get pods | grep mirror


#### 将升级包上传到mirror容器


kubectl -n ailpha-xdr cp AXDR-V2.0R25C40T054-X86-standard-mirror-5dfef425_16107adf-20260121020344.zip mirror-54d7c5d88d-r8kp8:/data/unzipmirror
#需要将命令中的AXDR-V2.0R25C40T054-X86-standard-mirror-5dfef425_16107adf-20260121020344.zip替换成当前升级包的名称
#mirror-54d7c5d88d-r8kp8替换成第一步查询到的mirror容器组id


### 解压升级包



#### 进入mirror容器


kubectl -n ailpha-xdr exec -it mirror-54d7c5d88d-r8kp8 bash
#将mirror-54d7c5d88d-r8kp8替换成第二步中查询到的容器组id


#### 进入升级包上传目录并解压包


cd /data/unzipmirror
unzip AXDR-V2.0R25C40T054-X86-standard-mirror-5dfef425_16107adf-20260121020344.zip
#升级包名称替换成当前升级包包名，执行命令之后会提示输入解压密码，解压密码：ePb%R7XW#$，解压成功后会生成一个.tar.gz结尾的文件


#### 上传文件


curl -X POST \
http://ailpha-init.kube-public:8000/api/v1/files \
-H 'Content-Type: multipart/form-data' \
-F 'name=AXDR-V2.0R25C40T054-X86-standard-mirror-5dfef425_16107adf-20260121020344-bin.tar.gz' \
-F 'type=service_update' \
-F 'file=@/data/unzipmirror/AXDR-V2.0R25C40T054-X86-standard-mirror-5dfef425_16107adf-20260121020344-bin.tar.gz' 
#name需替换成刚刚解压之后的文件名称，file里面的文件名称也要替换成刚刚解压之后的文件名称，执行之后返回结果如下：

{

"code": 0,

"message": "",

"data": {

"id": "1d27bed5-3058-4d17-a263-bd93d69c39b2",//文件id

"name": "AXDR-V2.0R25C40T054-X86-standard-mirror-5dfef425_16107adf-20260121020344-bin.tar.gz",

"url": "http://10.0.0.1:8000/api/v1/files/1d27bed5-3058-4d17-a263-bd93d69c39b2"

}

}


#### 升级


curl -X POST \
http://ailpha-init.kube-public:8000/api/v1/service/mirror \
-H 'Content-Type: application/json' \
-d '{
  "action": "doUpdate",
  "fileId": "1d27bed5-3058-4d17-a263-bd93d69c39b2",
  "version": "V2.0R25C40T054-X86-standard",
  "checksum": "dc4d5798680713eb07030f96249d11f8"
}'

fileId的值替换成第四步返回结果中的id值，version替换成当前升级包的版本号，checksum替换成解压文件的md5值

md5值查询命令：md5sum AXDR-V2.0R25C40T054-X86-standard-mirror-5dfef425_16107adf-20260121020344-bin.tar.gz //包名替换成当前解压之后的文件名

执行完成后续等5-10分钟才升级结束


![xdr升级超时后台升级步骤-k8s_img1.png](../assets/xdr升级超时后台升级步骤-k8s/xdr升级超时后台升级步骤-k8s_img1.png)

