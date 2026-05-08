---
title: root部署xdr
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# root部署xdr


tar -xzfv LUANBIRD-AXDR-V2.0R25C22-X86-2025110317.tar.gz
cd ansible
tools/lbctl cluster reset
tools/lbctl cluster init
#IP、密码根据情况修改
tools/lbctl node add master 172.16.103.112 -uroot -p'1qazcde3!@#' -P22
#型号根据实际情况修改
tools/lbctl cluster set -t AXDR1500
tools/lbctl cluster deploy
