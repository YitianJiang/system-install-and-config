#!/bin/bash
yum install -y wget
cd /opt
wget https://www.keepalived.org/software/keepalived-1.3.5.tar.gz
tar zxvf keepalived-1.3.5.tar.gz 
cd keepalived-1.3.5
./configure --prefix=/opt/keepalived --with-init=SYSV 
make && make install
cp /opt/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/
cp /opt/keepalived/etc/sysconfig/keepalived /etc/sysconfig
cp /opt/keepalived/sbin/keepalived /usr/sbin/
chmod +x /etc/init.d/keepalived 
chkconfig --add keepalived
chkconfig keepalived on
mkdir /etc/keepalived
cp /root/system-install-and-config/rabbitmq/keepalived-install/check_haproxy.sh /etc/keepalived

