#!/bin/bash
set -eux
exec 2>&1 1>>mysql-install.log 
cat << EOF >> /etc/my.cnf
relay-log=relay-log
relay-log-index=relay-log.index
server-id=$(ip addr | awk '/inet.*enp0s3/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}'| awk -F '.' '{print $4}')
innodb_file_per_table=ON
skip_name_resolve=ON
EOF
systemctl restart mysql
sleep 3
master_ip=$(grep master mysql_node_ips.txt | awk '{print $2})
res=($(mysql -uroot -p123456 -h${master_ip} -e "show master logs;" \
| sed '/mysql-bin/!d' | sed -n '$p' | awk -F '|' '{print $2,$3}'))
mysql -uroot -p123456 << EOF 
change master to master_host=${master_ip},master_user='repluser',\
master_password='replpass',master_log_file=${res[0]},master_log_pos=${res[1]};
start slave;
EOF



