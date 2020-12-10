#!/bin/bash
mkdir -p /opt/hadoop && cd /opt/hadoop
scp root@192.168.1.190:/root/big-data/hadoop-2.7.6.tar.gz .
tar -zxvf hadoop-2.9.2.tar.gz
mkdir -p /root/hadoop \
/root/hadoop/tmp \
/root/hadoop/var \
/root/hadoop/dfs \
/root/hadoop/dfs/name \
/root/hadoop/dfs/data
cd /opt/hadoop/hadoop-2.7.6/etc/hadoop
#modify the configuration file
#format hdfs and start hadoop

