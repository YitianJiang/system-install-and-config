#!/bin/bash
yum install -y epel-release
yum install -y rabbitmq-server
nohup /usr/lib/rabbitmq/bin/rabbitmq-server &
scp /var/lib/rabbitmq/.erlang.cookie root@192.168.1.201:/var/lib/rabbitmq/.erlang.cookie
scp /var/lib/rabbitmq/.erlang.cookie root@192.168.1.202:/var/lib/rabbitmq/.erlang.cookie
scp /var/lib/rabbitmq/.erlang.cookie root@192.168.1.203:/var/lib/rabbitmq/.erlang.cookie
/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management


