#!/bin/bash
#1.install haproxy
yum install -y wget
cd /opt
wget https://mirrors.huaweicloud.com/haproxy/1.7/src/haproxy-1.7.8.tar.gz
tar -zxvf haproxy-1.7.8.tar.gz
cd haproxy-1.7.8
yum install -y gcc
#if not specify the directory to install ,it will install like the following:
#install -d "/usr/local/sbin"
#install haproxy  "/usr/local/sbin"
#install -d "/usr/local/share/man"/man1
#install -m 644 doc/haproxy.1 "/usr/local/share/man"/man1
#install -d "/usr/local/doc/haproxy"
#for x in configuration management architecture cookie-options lua WURFL-device-detection proxy-protocol linux-syn-cookies network-namespaces DeviceAtlas-device-detection 51Degrees-device-detection netscaler-client-ip-insertion-protocol close-options SPOE intro; do \
#	install -m 644 doc/$x.txt "/usr/local/doc/haproxy" ; \
#done
make  TARGET=linux3100 CPU=x86_64
make install
mkdir /etc/haproxy
cp /root/system-install-and-config/rabbitmq/haproxy-install/haproxy.cfg /etc/haproxy
firewall-cmd --permanent --zone=public --add-port=5671/tcp
firewall-cmd --permanent --zone=public --add-port=8100/tcp
firewall-cmd --reload
haproxy -f /etc/haproxy/haproxy.cfg

#2.auto start
cp /root/system-install-and-config/rabbitmq/haproxy-install/haproxy /etc/init.d/
chkconfig --add haproxy
chkconfig --level 2345  haproxy on

