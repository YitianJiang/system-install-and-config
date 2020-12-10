#!/bin/bash
yum install -y epel-release
yum install -y rabbitmq-server
/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management
rabbitmqctl join_cluster --ram rabbit@$(hostname)
rabbitmqctl start_app

