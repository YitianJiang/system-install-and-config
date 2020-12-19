#!/bin/bash
#1.install docker 
cd /root/system-install-and-config && bash docker-install.sh

#2.open ports
firewall-cmd --zone=public --permanent --add-port=2376/tcp 
firewall-cmd --zone=public --permanent --add-port=10250/tcp
firewall-cmd --zone=public --permanent --add-port=10254/tcp
firewall-cmd --zone=public --permanent --add-port=6443/tcp
firewall-cmd --zone=public --permanent --add-port=9099/tcp
firewall-cmd --zone=public --permanent --add-port=8472/udp
firewall-cmd --reload

#3.close swap
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab 

#4.install and configure chrony
if [[ `chronyd --version 2>&1 | grep "command not found" | wc -l` -eq 1 ]]; then 
        yum install -y chrony
fi
masterip=10.0.0.200
cluster_network=10.0.0.0/24
sed -i "7i server  $masterip iburst\nallow $cluster_network" /etc/chrony.conf
systemctl start chronyd
systemctl enable chronyd

#5.install kubectl 
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
if [ ! -d "/root/.kube" ]; then
  mkdir ~/.kube
fi
touch ~/.kube/config


 
