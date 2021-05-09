if [[ $JAVA_HOME == "" ]]; then
    bash /root/system-install-and-config/java/openjdk-install-config.sh
fi
#when zkVersion is 3.5.9 or 3.7.0,the below error will emerge:
#"Could not find or load main class org.apache.zookeeper.server.quorum"
zkVersion=3.4.9
if [[ $1 != "" ]]; then
    zkVersion=$1
fi
cd /root
wget http://archive.apache.org/dist/zookeeper/zookeeper-${zkVersion}/zookeeper-${zkVersion}.tar.gz
tar zxvf zookeeper-${zkVersion}.tar.gz
cp /root/system-install-and-config/zookeeper/zoo.cfg /root/zookeeper-${zkVersion}/conf
mkdir /root/zookeeper-${zkVersion}/data
mkdir /root/zookeeper-${zkVersion}/logs
cat << EOF >> /root/zookeeper-${zkVersion}/conf/zoo.cfg
dataDir=/root/zookeeper-${zkVersion}/data
dataLogDir=/root/zookeeper-${zkVersion}/logs
EOF
. /root/zookeeper-${zkVersion}/bin/zkServer.sh start
