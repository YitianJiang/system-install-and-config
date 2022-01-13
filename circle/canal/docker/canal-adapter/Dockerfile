FROM centos
RUN yum install -y wget &&
wget https://github.com/alibaba/canal/releases/download/canal-1.1.4/canal.deployer-1.1.4.tar.gz &&
cd / &&
mkdir canal &&
tar -zxvf canal.deployer-1.1.4.tar.gz -C canal &&
rm -rf canal/conf/example/instance.properties
COPY instance.properties canal/conf/example
EXPOSE 8082
ENTRYPOINT ["/canal/bin/startup.sh"]
