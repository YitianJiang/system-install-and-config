############################################通用##################################################################
set -ex
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
set -u
exec 2>$SYSTEM_INSTALL_AND_CONFIG/log
############################################通用##################################################################

bash $SYSTEM_INSTALL_AND_CONFIG/docker-install.sh

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

#下载安装Docker Compose
curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

####################################################配置环境###################################################################
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


#配置mysql
cp $SYSTEM_INSTALL_AND_CONFIG/circle/circle.sql /mydata/circle.sql
docker cp /mydata/circle.sql mysql:/
ConfigMysql(){
sleep 10
docker exec -i mysql /bin/bash << EOF  2>&1 | grep ERROR
#连接到mysql服务
mysql -uroot -proot --default-character-set=utf8 << END
#创建远程访问用户
grant all privileges on *.* to 'reader' @'%' identified by '123456';
#创建数据库
drop database if exists circle;
create database circle character set utf8;
#使用circle数据库
use circle;
#导入circle.sql脚本
source /circle.sql;
END
EOF
return $?
}
tmp=$(ConfigMysql)
while [[ $? == 0 ]]
do 
    echo "error emerge ,try again"
    tmp=$(ConfigMysql)
done

####################################################安装启动应用###################################################################
docker login --username=jiangyitian123456  -p jiang123456 registry.cn-hangzhou.aliyuncs.com
docker-compose -f $SYSTEM_INSTALL_AND_CONFIG/circle/docker-compose-app.yml up -d

#配置文件上传nacos
set +e
filelist=$(find $SYSTEM_INSTALL_AND_CONFIG/circle/app-config -name *.yaml)
for file in $filelist
do
    #urlencode "#" and "&", or encoding problem will emerge 
    filestr=$(< $file)
    filestr=${filestr//#/%23}
    filestr=${filestr//&/%26}
    curl -X POST 'http://127.0.0.1:8848/nacos/v1/cs/configs' \
    -d 'dataId='"$(basename $file)"'&group=DEFAULT_GROUP&content='"$filestr"'&type=yaml'
done