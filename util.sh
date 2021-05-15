getIp(){
    if [[ $(ip addr | grep enp0s3$) != "" ]]; then  #virtual box
        serverIp=$(ip addr | awk '/inet.*enp0s3/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
    elif [[ $(ip addr | grep eth0$) != "" ]]; then  #aliyun ecs
        serverIp=$(ip addr | awk '/inet.*eth0/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
    fi
    echo $serverIp
}