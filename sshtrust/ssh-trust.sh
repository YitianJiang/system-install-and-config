#!/bin/bash
if [[ `expect --version 2>&1 | grep "command not found" | wc -l` -eq 1 ]]; then 
  yum install -y expect
fi
if [[ `cd ~/.ssh && ls | grep id_rsa.pub | wc -l` -eq 0 ]]; then
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
fi
[ $# -gt 0 -a -f "$1" ] || exit 1
user=root
password=123456
ipaddr=$(ip addr | awk '/inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
cat $1 | while read ip ;do
    if [[ $ip != $ipaddr ]]; then
      expect ssh-copy-id.exp $ip $user $password
    fi
done


