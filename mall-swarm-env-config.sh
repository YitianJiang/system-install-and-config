#!/bin/bash
bash /root/system-install-and-config/docker-install.sh

# allow uploading images to docker  
firewall-cmd --zone=public --permanent --add-port=2375/tcp
firewall-cmd --reload
sed -i 's/^ExecStart.*/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/0.0.0.0:2375 -H unix:\/\/var\/run\/docker.sock/' \
/usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker

docker pull mysql:5.7
docker pull redis:5
docker pull nginx:1.10
docker pull rabbitmq:3.7.15-management
docker pull elasticsearch:7.6.2
docker pull kibana:7.6.2
docker pull logstash:7.6.2
docker pull mongo:4.2.5

cd /root
git clone https://github.com/YitianJiang/mall-swarm.git

# 改变设置
sysctl -w vm.max_map_count=262144
# 使之立即生效
sysctl -p

# 创建目录
mkdir -p /mydata/elasticsearch/data/
# 创建并改变该目录权限
chmod 777 /mydata/elasticsearch/data

# 创建目录之后将nginx.conf文件上传到该目录下面
mkdir -p /mydata/nginx/
cp /root/mall-swarm/document/docker/nginx.conf /mydata/nginx/

mkdir -p /mydata/logstash
cp /root/mall-swarm/document/elk/logstash.conf /mydata/logstash

#下载安装Docker Compose
curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

docker-compose -f /root/mall-swarm/document/docker/docker-compose-env.yml up -d
docker ps

#mysql
#1. 
#it's strange , when I use tab key to change code format to the below, 
# docker exec -i mysql /bin/bash << EOF
#     #连接到mysql服务
#     mysql -uroot -proot --default-character-set=utf8 << END
#         #创建远程访问用户
#         grant all privileges on *.* to 'reader' @'%' identified by '123456';
#         #创建mall数据库
#         create database mall character set utf8;
#         #使用mall数据库
#         use mall;
#         #导入mall.sql脚本
#         source /mall.sql;
#     END
# EOF
#an error will occur.
#2.
# If I set sleep for 5 seconds, an error will emerge, sometimes it will be 
#"Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock'" ,
# and sometimes "Access denied for user'root'@'localhost' (using password: YES)",
# but if I set sleep to 20 seconds, there will be no error occur.
# I guess it need time to configure the envirenment to well.
# sleep 20
# this time ,the error also emerge
cp /root/mall-swarm/document/sql/mall.sql /mydata/mall.sql
docker cp /mydata/mall.sql mysql:/
ConfigMysql(){
sleep 10
docker exec -i mysql /bin/bash << EOF  2>&1 | grep ERROR
#连接到mysql服务
mysql -uroot -proot --default-character-set=utf8 << END
#创建远程访问用户
grant all privileges on *.* to 'reader' @'%' identified by '123456';
#创建mall数据库
create database mall character set utf8;
#使用mall数据库
use mall;
#导入mall.sql脚本
source /mall.sql;
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

#elasticsearch
docker exec -i elasticsearch /bin/bash << EOF
elasticsearch-plugin install -b https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.6.2/elasticsearch-analysis-ik-7.6.2.zip
EOF
docker restart elasticsearch

#logstash
docker exec -i logstash /bin/bash << EOF
logstash-plugin install logstash-codec-json_lines
EOF
docker restart logstash

#rabbitmq 
# It's very strange ,in other scenarios , I can use "<< EOF" to wrap mutiple commands , 
# and all the commands can be excuted,
# but in this case, only the first command can be executed, the other not. 
docker exec -i rabbitmq /bin/bash << EOF
rabbitmqctl add_user mall mall
EOF
docker exec -i rabbitmq /bin/bash << EOF
rabbitmqctl set_user_tags mall administrator
EOF
docker exec -i rabbitmq /bin/bash << EOF
rabbitmqctl add_vhost /mall
EOF
docker exec -i rabbitmq /bin/bash << EOF
rabbitmqctl set_permissions -p /mall mall ".*" ".*" ".*"
EOF

#nacos
filelist=$(find /root/mall-swarm/config -name *.yaml)
for file in $filelist
do
    #urlencode "#" and "&", or encoding problem will emerge 
    filestr=$(< $file)
    filestr=${filestr//#/%23}
    filestr=${filestr//&/%26}
    curl -X POST 'http://10.0.0.201:8848/nacos/v1/cs/configs' \
    -d 'dataId='"$(basename $file)"'&group=DEFAULT_GROUP&content='"$filestr"'&type=yaml'
done

#pull images and run app
docker pull 2138127826/mall-gateway:1.0-SNAPSHOT
docker pull 2138127826/mall-auth:1.0-SNAPSHOT
docker pull 2138127826/mall-monitor:1.0-SNAPSHOT
docker pull 2138127826/mall-admin:1.0-SNAPSHOT
docker pull 2138127826/mall-portal:1.0-SNAPSHOT
docker pull 2138127826/mall-search:1.0-SNAPSHOT

docker-compose -f /root/mall-swarm/document/docker/docker-compose-app.yml up -d
