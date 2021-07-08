############################################通用##################################################################
set -ex
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
############################################通用##################################################################

bash $SYSTEM_INSTALL_AND_CONFIG/docker-install.sh

if [[ $(docker ps | grep zookeeper) != "" ]]; then
	echo "zookeeper has been installed"
	exit 0
fi

#########################################设置默认参数 通过输入参数覆盖默认配置########################################
#when zkVersion is 3.5.9 or 3.7.0,the below error will emerge:
#"Could not find or load main class org.apache.zookeeper.server.quorum"
version=3.4.9
confDir=/root/zookeeper-${version}/conf
dataDir=/root/zookeeper-${version}/data
logDir=/root/zookeeper-${version}/logs
TEMP=`getopt -o v:c:d:l: -a -l version:,confDir:,dataDir:,logDir: -n "ERROR" -- "$@"`
 
# 判定 getopt 的执行时候有错，错误信息输出到 STDERR
if [ $? != 0 ]
then
	echo "Terminating....." >&2
	exit 1
fi
 
# 重新排列参数的顺序
# 使用eval 的目的是为了防止参数中有shell命令，被错误的扩展。
eval set -- "$TEMP"
echo $@ 
# 处理具体的选项
while true
do
	case "$1" in
		-v | --version | -version) version=$2
						echo "option v, argument $2"
						shift 2
						;;
		-c | --confDir | -confDir) confDir=$2
						echo "option c, argument $2"
						shift 2
						;;
		-d | --dataDir | -dataDir) dataDir=$2
						echo "option d, argument $2"
						shift 2
						;;
		-l | --logDir | -logDir) logDir=$2
			echo "option l, argument $2"
			shift 2
			;;
		--)
			shift
			break
			;;
		*) 
			echo "Internal error!"
			exit 1
			;;
	esac
done
#########################################设置默认参数 通过输入参数覆盖默认配置##############################################

docker pull zookeeper:${version}

mkdir -p ${confDir}
cp $SYSTEM_INSTALL_AND_CONFIG/zookeeper/zoo.cfg ${confDir}

# sed -i '/dataDir=/d' ${confDir}/zoo.cfg  #先删除原有的
# echo dataDir=${dataDir} >> ${confDir}/zoo.cfg  #再添加新的 

# sed -i '/dataLogDir=/d' ${confDir}/zoo.cfg
# echo dataLogDir=${logDir} >> ${confDir}/zoo.cfg 
cat << EOF >> ${confDir}/zoo.cfg
dataDir=/zookeeper-${version}/data
dataLogDir=/zookeeper-${version}/logs
EOF

docker run -d --name zookeeper \
--restart=always \
-p 2181:2181 \
-v ${confDir}:/zookeeper-${version}/conf \
-v ${dataDir}:/zookeeper-${version}/data \
-v ${logDir}:/zookeeper-${version}/logs \
zookeeper:${version}

