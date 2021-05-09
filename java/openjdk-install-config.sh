yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
temp=$(dirname $(readlink $(readlink $(which java))))

cat << EOF >>/etc/profile
export JAVA_HOME=${temp%/jre/bin*}
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
EOF
source /etc/profile
echo $JAVA_HOME