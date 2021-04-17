if [[ `wget --version | wc -l` -lt 10 ]]; then
    yum install -y wget

wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql-community-server
cat << EOF >> /etc/my.cnf 
#添加validate_password_policy配置
validate_password_policy=0
#关闭密码策略
validate_password = off

# 修改mysql的字符编码
character_set_server=utf8
init_connect='SET NAMES utf8'
EOF
systemctl start  mysqld.service
sleep 5
passwordStr=`grep "A temporary password is generated for root@localhost" /var/log/mysqld.log`
password=${passwordStr#*root@localhost: }
mysql --connect-expired-password -uroot -p$password <<EOF
alter user 'root'@'localhost' identified by '123456';
grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option;
flush privileges; 
EOF
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

