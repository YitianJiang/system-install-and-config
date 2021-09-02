############################################通用##################################################################
set -ex
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
set -u
exec 2>$SYSTEM_INSTALL_AND_CONFIG/log
############################################通用##################################################################
#参考 https://www.cnblogs.com/caoweixiong/p/11825303.html

#下载解压
cd ~ && wget https://github.com/alibaba/canal/releases/download/canal-1.1.4/canal.deployer-1.1.4.tar.gz
mkdir -p /usr/local/canal
tar zxvf canal.deployer-1.1.4.tar.gz  -C /usr/local/canal

#替换原来的instance.properties文件
rm -rf /usr/local/canal/conf/example/instance.properties
cp  $SYSTEM_INSTALL_AND_CONFIG/circle/canal/instance.properties /usr/local/canal/conf/example

#先关掉 再启动 保证幂等性
bash /usr/local/canal/bin/stop.sh && bash /usr/local/canal/bin/startup.sh

#下载解压
wget https://github.com/alibaba/canal/releases/download/canal-1.1.5/canal.adapter-1.1.5.tar.gz
mkdir -p /usr/local/canal-adapter
tar zxvf canal.adapter-1.1.5.tar.gz -C /usr/local/canal-adapter

#替换原来的application.yml文件
rm -rf /usr/local/canal-adapter/conf/application.yml
cp  $SYSTEM_INSTALL_AND_CONFIG/circle/canal/application.yml  /usr/local/canal-adapter/conf

#新增输出到es的配置文件
[ ! -f /usr/local/canal-adapter/conf/es7/canal.yml ] && \
cp  $SYSTEM_INSTALL_AND_CONFIG/circle/canal/canal.yml  /usr/local/canal-adapter/conf/es7

#替换原来的client-adapter.es7x-1.1.5-jar-with-dependencies.jar 原来的会报
#java.lang.ClassCastException: com.alibaba.druid.pool.DruidDataSource cannot be cast to com.alibaba.druid.pool.DruidDataSource
#这个包是修改后重新打包生成的
#参考： https://www.cnblogs.com/agilestyle/p/15075936.html
rm -rf /usr/local/canal-adapter/plugin/client-adapter.es7x-1.1.5-jar-with-dependencies.jar
cp  $SYSTEM_INSTALL_AND_CONFIG/circle/canal/client-adapter.es7x-1.1.5-jar-with-dependencies.jar  /usr/local/canal-adapter/plugin

#启动canal-adapter
bash /usr/local/canal-adapter/bin/stop.sh  &&  bash /usr/local/canal-adapter/bin/startup.sh

