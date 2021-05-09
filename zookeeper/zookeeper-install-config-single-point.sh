zkVersion=3.5.9
if [[ $1 != "" ]]; then
    zkVersion=$1
fi
cd /root
wget https://downloads.apache.org/zookeeper/zookeeper-${zkVersion}/apache-zookeeper-${zkVersion}.tar.gz 
tar zxvf apache-zookeeper-${zkVersion}.tar.gz
cp /root/system-install-and-config/zookeeper/zoo.cfg /root/apache-zookeeper-${zkVersion}/conf
mkdir /root/apache-zookeeper-${zkVersion}/data
mkdir /root/apache-zookeeper-${zkVersion}/logs
cat << EOF >> /root/apache-zookeeper-${zkVersion}/conf/zoo.cfg
dataDir=/root/apache-zookeeper-${zkVersion}/data
dataLogDir=/root/apache-zookeeper-${zkVersion}/logs
EOF 
. /root/apache-zookeeper-${zkVersion}/bin/zkServer.sh start
