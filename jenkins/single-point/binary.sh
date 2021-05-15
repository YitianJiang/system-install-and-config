if [[ $JAVA_HOME == "" ]]; then
    bash /root/system-install-and-config/java/openjdk-install-config.sh
fi
yum install -y wget
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y
systemctl start jenkins
systemctl status jenkins


