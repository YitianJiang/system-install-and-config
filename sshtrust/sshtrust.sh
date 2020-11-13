#!/bin/bash
#it can be execute in both manager host and hosts the manager manages
#-n --nomal -a --add
if [[ `expect --version 2>&1 | grep "command not found" | wc -l` -eq 1 ]]; then 
	yum install -y expect
fi
if [[ `cd ~/.ssh && ls | grep id_rsa.pub | wc -l` -eq 0 ]]; then
	ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
fi
user=root
password=123456
if [[ $1 == "-n" ]]; then
	localip=$(ip addr | awk '/inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
	while read ip ;do
		if [[ $ip != $localip ]]; then
			expect ssh-copy-id.exp $ip $user $password
		fi
	done < iplist.txt
elif [[ $1 == "-a" ]]; then
	expect ssh-copy-id.exp $2 $user $password
fi


