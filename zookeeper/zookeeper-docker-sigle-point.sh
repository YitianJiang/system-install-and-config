bash /root/system-install-and-config/docker-install.sh
docker pull zookeeper
docker run -d --name zookeeper -p 2181:2181 zookeeper
