############################################通用##################################################################
set -eux
if [[ $SYSTEM_INSTALL_AND_CONFIG == "" ]]; then
	export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
fi
############################################通用##################################################################

bash $SYSTEM_INSTALL_AND_CONFIG/zookeeper/zookeeper-docker-single-point.sh

source $SYSTEM_INSTALL_AND_CONFIG/util.sh
ip=$(getIp)

docker run  -d --name kafka \
-p 9092:9092 \
--link zookeeper:zookeeper \
-e KAFKA_BROKER_ID=0 \
-e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
-e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://${ip}:9092 \
-e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
-t wurstmeister/kafka \