### 编写原则：

1. 脚本尽量不要与固定ip绑定
   填写当前主机ip时,可以util中的getIp方法获取
2. 幂等性 脚本多次执行的效果要和一次执行的效果一样
   这里主要在写文件的时候遇到（添加配置或者环境变量）
3. 脚本单独执行和在其他脚本调用执行效果一样
   类似这样的：cp ./zoo.cfg ${confDir}
   就不能满足原则3，单独调用的时候可以，但是如果放到脚本a里然后该a脚本又被另一个脚本b调用，这时获取的是b脚本的路径
   另一种情况是: source ../util
   如果b脚本的上级目录就是system-install-and-config还好，如果不是，在a脚本里面写上这么一句就不会满足
   原则3
   一般使用 "." 或者".." 这样的相对路径的时候不会满足原则3，所以脚本里面不要出现相对路径 
   可以通过在每个脚本首部加上下面一段获取system-install-and-config根路径改写：

``` shell
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
```

4. if条件只有一个分支时，使用[[ xxx ]] && xxx,而不是if[ xxx ]; then xxx; fi 如：

```shell
  if [[ $SYSTEM_INSTALL_AND_CONFIG == "" ]]; then
　　export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
  fi
```

　应写为：

```shell
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
```
5. docker 安装时，应加上" --volume /etc/localtime:/etc/localtime "让docker时间和主机时间同步。

### 目录规范：

```java
jenkins -- 项目名称
├── cluster -- 集群安装
├── single-point -- 单点安装
    ├── binary.sh -- 二进制方式安装的.sh文件
    ├── docker.sh -- docker方式安装的.sh文件
    ├── xxx.cfg -- 配置文件
```

