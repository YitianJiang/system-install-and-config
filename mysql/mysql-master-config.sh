#!/bin/bash
exec 2>&1 1>>mysql-install.log
cat << EOF >> /etc/my.cnf
log-bin = mysql-bin
server-id = 1
innodb-file-per-table = ON
skip_name_resolve = ON
EOF
systemctl restart mysql
sleep 3
slave_ips=(`grep slave mysql_node_ips.txt | awk '{print $2}'`)
for slave_ip in slave_ips; do
    mysql -uroot -p123456 << EOF
    grant replication slave, replication client on *.* to 'repluser'@'${slave_ip}' identified by 'replpass';
    flush privileges;
    EOF
done



