#!/bin/bash
cd /root/system-install-and-config && bash docker-install.sh

firewall-cmd --zone=public --permanent --add-port=80/tcp 
firewall-cmd --zone=public --permanent --add-port=443/tcp
firewall-cmd --reload

docker run -d --restart=unless-stopped -p 80:80 -p 443:443 --privileged rancher/rancher



 
