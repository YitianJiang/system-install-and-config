#!/bin/sh
yum install -y vim
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y --setopt=obsoletes=0 \
   docker-ce-17.03.2.ce-1.el7.centos.x86_64 \
   docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
docker --version
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
systemctl start docker
systemctl enable docker
docker info |grep Storage
