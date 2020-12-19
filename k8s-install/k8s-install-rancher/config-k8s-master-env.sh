#!/bin/bash
cd /root/system-install-and-config && bash docker-install.sh

firewall-cmd --zone=public --permanent --add-port=2376/tcp 
firewall-cmd --zone=public --permanent --add-port=10250/tcp
firewall-cmd --zone=public --permanent --add-port=10254/tcp
firewall-cmd --zone=public --permanent --add-port=6443/tcp
firewall-cmd --zone=public --permanent --add-port=9099/tcp
firewall-cmd --zone=public --permanent --add-port=8472/udp
firewall-cmd --reload

swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab 

if [[ `chronyd --version 2>&1 | grep "command not found" | wc -l` -eq 1 ]]; then 
        yum install -y chrony
fi
masterip=10.0.0.200
cluster_network=10.0.0.0/24
sed -i "7i server  $masterip iburst\nallow $cluster_network" /etc/chrony.conf
systemctl start chronyd
systemctl enable chronyd


 
