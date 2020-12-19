#!/bin/bash

#1.add host ip:hostname mappings to /etc/hosts
if [[ $(grep "10.0.0.200 k8s-master" /etc/hosts) == "" ]]; then
  sed -i '$a 10.0.0.200 k8s-master' /etc/hosts
fi 

if [[ $(grep "10.0.0.201 k8s-slave1" /etc/hosts) == "" ]]; then
  sed -i '$a 10.0.0.201 k8s-slave1' /etc/hosts
fi
 
if [[ $(grep "10.0.0.202 k8s-slave2" /etc/hosts) == "" ]]; then
  sed -i '$a 10.0.0.202 k8s-slave2' /etc/hosts
fi
 
#2.open ports
firewall-cmd --zone=public --permanent --add-port=4369/tcp
firewall-cmd --zone=public --permanent --add-port=5672/tcp
firewall-cmd --zone=public --permanent --add-port=15672/tcp
firewall-cmd --zone=public --permanent --add-port=25672/tcp
firewall-cmd --reload

#3.yum install rabbitmq-serveri ,it may be too slow.
yum install -y epel-release rabbitmq-server

#4.open plugin
/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

#5.start one node
#configure the two .erlang.cookie in the node to be consistent(the one subject to another in /root)
#copy .erlang.cookie to other nodes
scp root@10.0.0.200:/root/.erlang.cookie /root/.erlang.cookie
\cp -f /root/.erlang.cookie /var/lib/rabbitmq/.erlang.cookie 
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
/usr/lib/rabbitmq/bin/rabbitmq-server -detached

#6.join cluster
rabbitmqctl stop_app
rabbitmqctl join_cluster --ram rabbit@k8s-master
rabbitmqctl start_app

#7.configure auto start
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/User=rabbitmq/User=root/g' /usr/lib/systemd/system/rabbitmq-server.service
sed -i 's/Group=rabbitmq/Group=root/g' /usr/lib/systemd/system/rabbitmq-server.service
systemctl enable rabbitmq-server


