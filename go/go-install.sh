# 安装wget
yum install -y wget
# 下载
wget https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz
# 解压压缩包到/usr/local目录
tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz
# 将/usr/local/go/bin 目录添加至PATH环境变量
# vi /etc/profile
# export PATH=$PATH:/usr/local/go/bin
# 命令行添加  最方便
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile

# 重新读取
source /etc/profile
# 查看版本
go version

#安装delve
git clone https://github.com/go-delve/delve.git
cd delve
go install github.com/go-delve/delve/cmd/dlv
dlv version