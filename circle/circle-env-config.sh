#1. install,config and start mysql
bash /root/system-install-and-config/docker-install.sh

docker pull mysql:5.7
containerId=$(docker run -p 3306:3306 --name mysql \
-v /mydata/mysql/log:/var/log/mysql \
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql \
-e MYSQL_ROOT_PASSWORD=root  \
-d mysql:5.7)
cp /root/system-install-and-config/circle/my.cnf /mydata/mysql/conf
docker restart $containerId

docker cp /root/system-install-and-config/circle/circle.sql mysql:/
ConfigMysql(){
sleep 10
docker exec -i mysql /bin/bash << EOF  2>&1 | grep ERROR
mysql -uroot -proot << END
grant all privileges on *.* to 'reader' @'%' identified by '123456';
create database circle;
use circle;
source /circle.sql;
END
EOF
return $?
}
tmp=$(ConfigMysql)
while [[ $? == 0 ]]
do 
    echo "error emerge ,try again"
    tmp=$(ConfigMysql)
done

#2.pull circle image from dockerhub and start it
docker pull 2138127826/main:0.0.2-SNAPSHOT
docker run -p 8088:8088 --name circle-main \
--link mysql:db \
-v /etc/localtime:/etc/localtime \
-v /mydata/app/main/logs:/var/logs \
-d 2138127826/main:0.0.2-SNAPSHOT
