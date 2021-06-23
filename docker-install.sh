#!/bin/sh
if [[ `docker --version 2>&1 | grep "command not found" | wc -l` -eq 0 ]]; then
  echo "docker has been installed" && exit 0
fi

sed -i '/net.bridge.bridge-nf-call-ip6tables/d' /etc/sysctl.conf
sed -i '/net.bridge.bridge-nf-call-iptables/d' /etc/sysctl.conf
cat << EOF >>/etc/sysctl.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
modprobe br_netfilter
sysctl -p
yum -y install yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y --setopt=obsoletes=0 install \
   docker-ce-17.03.2.ce-1.el7.centos.x86_64 \
   docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
systemctl start docker
sleep 3
touch /etc/docker/daemon.json
cat << EOF >/etc/docker/daemon.json
{
  "registry-mirrors": ["https://k5jkewij.mirror.aliyuncs.com"],
  "storage-driver": "overlay2",
  "storage-opts": [
  "overlay2.override_kernel_check=true"
  ]
}
EOF
systemctl daemon-reload
systemctl restart docker
systemctl enable docker
docker info
