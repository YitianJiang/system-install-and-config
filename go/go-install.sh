# 安装wget
yum install -y wget
# 下载
wget https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz
# 解压压缩包到/usr/local目录
tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz
#删除原来的PATH
sed -i '/^export PATH=/d' /etc/profile
#写进新的PATH
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile

# 重新读取
source /etc/profile
# 查看版本
go version

#安装delve
git clone https://github.com/go-delve/delve
cd delve
go install github.com/go-delve/delve/cmd/dlv
sed -i '/^export PATH=/d' /etc/profile
echo "export PATH=$PATH:/root/go/bin" >> /etc/profile
source /etc/profile
dlv version