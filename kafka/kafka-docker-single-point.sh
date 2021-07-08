############################################通用##################################################################
set -ex
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
############################################通用##################################################################

#先安装zookeeper
bash $SYSTEM_INSTALL_AND_CONFIG/zookeeper/zookeeper-docker-single-point.sh

source $SYSTEM_INSTALL_AND_CONFIG/util.sh
ip=$(getIp)

#安装kafka
docker run  -d --name kafka \
-p 9092:9092 \
--link zookeeper:zookeeper \
-e KAFKA_BROKER_ID=0 \
-e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
-e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://${ip}:9092 \
-e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
--restart=always \
--volume /etc/localtime:/etc/localtime \
-t wurstmeister/kafka \

#安装kafkamanager
docker run -d --name kafka-manager \
--link zookeeper:zookeeper \
--link kafka:kafka \
-p 9000:9000 \
--restart=always \
--env ZK_HOSTS=zookeeper:2181 \
--volume /etc/localtime:/etc/localtime \
sheepkiller/kafka-manager