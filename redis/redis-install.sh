#!/bin/bash
yum install -y gcc wget gcc-c++ make tcl
mkdir /opt/redis 
cd /opt/redis
wget https://mirrors.huaweicloud.com/redis/redis-6.0.9.tar.gz
tar zxvf redis-6.0.9.tar.gz
cd redis-6.0.9
yum -y install centos-release-scl
yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
scl enable devtoolset-9 bash
#if use gcc 9.1 for a long time,  uncomment the following: 
#if [[ $(grep "source /opt/rh/devtoolset-9/enable" /etc/profile) == "" ]]; then
#  sed -i '$a source /opt/rh/devtoolset-9/enable' /etc/profile
#fi
make && make install PREFIX=/usr/local/redis
cp /root/system-install-and-config/redis/redis.conf /opt/redis/redis-6.0.9
mkdir /opt/redis/redis-6.0.9/data
firewall-cmd --zone=public --permanent --add-port=6379/tcp
firewall-cmd --reload
/usr/local/redis/bin/redis-server /opt/redis/redis-6.0.9/redis.conf
cp /root/system-install-and-config/redis/redis.service /lib/systemd/system
systemctl enable redis


