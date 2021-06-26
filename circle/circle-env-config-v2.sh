############################################通用##################################################################
set -ex
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
set -u
exec 2>$SYSTEM_INSTALL_AND_CONFIG/log
############################################通用##################################################################

bash $SYSTEM_INSTALL_AND_CONFIG/docker-install.sh

docker pull zookeeper:3.4.9
docker pull wurstmeister/kafka
docker pull sheepkiller/kafka-manager
docker pull elasticsearch:7.6.2
docker pull logstash:7.6.2
docker pull kibana:7.6.2

#logstash 宿主机挂载目录创建
mkdir -p /mydata/logstash
cp $SYSTEM_INSTALL_AND_CONFIG/circle/logstash.conf /mydata/logstash

#es 宿主机挂载目录创建 及 系统参数调整
sysctl -w vm.max_map_count=262144
sysctl -p
mkdir -p /mydata/elasticsearch/data/
chmod 777 /mydata/elasticsearch/data

#zookeeper 宿主机挂载目录创建
mkdir -p /mydata/zookeeper/conf  /mydata/zookeeper/data /mydata/zookeeper/logs
cp $SYSTEM_INSTALL_AND_CONFIG/circle/zoo.cfg /mydata/zookeeper/conf

#下载安装Docker Compose 及启动各容器
curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose -f $SYSTEM_INSTALL_AND_CONFIG/circle/docker-compose-env.yml up -d

#安装logstash插件
# use "set +e" to avoid exiting when the following errors occur:
#   OpenJDK 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future release.
#   WARNING: An illegal reflective access operation has occurred
#   WARNING: Illegal reflective access by com.headius.backport9.modules.Modules to method sun.nio.ch.NativeThread.signal(long)
#   WARNING: Please consider reporting this to the maintainers of com.headius.backport9.modules.Modules
#   WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
#   WARNING: All illegal access operations will be denied in a future release
set +e
docker exec -i logstash /bin/bash << EOF
logstash-plugin install logstash-codec-json_lines
EOF
set -e
docker restart logstash

#安装es插件
docker exec -i elasticsearch /bin/bash << EOF
elasticsearch-plugin install -b https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.6.2/elasticsearch-analysis-ik-7.6.2.zip
EOF
docker restart elasticsearch