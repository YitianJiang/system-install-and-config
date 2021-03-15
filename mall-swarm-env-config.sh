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

mkdir /mydata/logstash
cp /root/mall-swarm/document/elk/logstash.conf /mydata/logstash

#下载安装Docker Compose
curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

docker-compose -f /root/mall-swarm/document/docker/docker-compose-env.yml up -d
docker ps
