yum install -y java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64
yum install -y java-1.8.0-openjdk-devel-1.8.0.212.b04-0.el7_6.x86_64
echo << EOF >>/etc/profile
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
EOF
source /etc/profile