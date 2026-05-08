---
title: k8s 解除禁ping
tags: []
created: 2026-05-08
type: permanent
summary: 
---


# k8s-解除禁ping



## 版本


R25C20以上


## 步骤


kubectl edit ciliumclusterwidenetworkpolicies.cilium.io control-plane-apiserver

加入红框内的信息

apiVersion: cilium.io/v2
kind: CiliumClusterwideNetworkPolicy
metadata:
  creationTimestamp: "2025-09-18T06:11:48Z"
  generation: 2
  name: control-plane-apiserver
  resourceVersion: "389921"
  uid: 267e3404-fbb5-4ec5-bed3-b49f680c974c
spec:
  description: Allow Kubernetes API Server to Control Plane
  ingress:
  - icmps:
    - fields:
      - family: IPv4
        type: 8
      - family: IPv4
        type: 0
      - family: IPv4
        type: 3
  - toPorts:
    - ports:
      - port: "6443"
        protocol: TCP
      - port: "9443"
        protocol: TCP
      - port: "2379"
        protocol: TCP
      - port: "4240"
        protocol: TCP
      - port: "5000"
        protocol: TCP
      - port: "5001"
        protocol: TCP
      - port: "8472"
        protocol: UDP
  nodeSelector:
    matchLabels:
      node-role.kubernetes.io/control-plane: ""


![k8s-解除禁ping_img1.png](../assets/k8s-解除禁ping/k8s-解除禁ping_img1.png)

