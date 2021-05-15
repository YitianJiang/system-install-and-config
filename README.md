### 编写原则：

1.脚本尽量不要与固定ip绑定

2.幂等性 脚本多次执行的效果要和一次执行的效果一样



### 目录规范：

```java
jenkins -- 项目名称
├── cluster -- 集群安装
├── single-point -- 单点安装
    ├── binary.sh -- 二进制方式安装的.sh文件
    ├── docker.sh -- docker方式安装的.sh文件
    ├── xxx.cfg -- 配置文件
```

