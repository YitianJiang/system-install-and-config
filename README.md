### 编写原则：

1.脚本尽量不要与固定ip绑定

2.幂等性 脚本多次执行的效果要和一次执行的效果一样

### 目录规范：

```java
jenkins
├── cluster -- 工具类及通用代码模块
├── single-point -- MyBatisGenerator生成的数据库操作代码模块
├── mall-auth -- 基于Spring Security Oauth2的统一的认证中心
```

