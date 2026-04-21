## 部署流程

### 1. 进入 ansible 目录
```bash
cd ansible
```

### 2. 重置集群
```bash
tools/lbctl cluster reset
```

### 3. 初始化集群
```bash
tools/lbctl cluster init
```

### 4. 添加主节点
```bash
tools/lbctl node add master 1 -uroot -p'ewSL_5zK0VQV' -P22
```

### 5. 设置集群类型
```bash
tools/lbctl cluster set -t AXDR1000
```

### 6. 部署集群
```bash
tools/lbctl cluster deploy
```

## 注意事项

- 执行顺序必须按上述步骤进行，不可跳过
- 添加主节点时需指定正确的 root 密码
- 部署前确保网络连通性

