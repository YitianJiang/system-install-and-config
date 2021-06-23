#获取ip
getIp(){
    if [[ $(ip addr | grep enp0s3$) != "" ]]; then  #virtual box
        serverIp=$(ip addr | awk '/inet.*enp0s3/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
    elif [[ $(ip addr | grep eth0$) != "" ]]; then  #aliyun ecs
        serverIp=$(ip addr | awk '/inet.*eth0/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
    fi
    echo $serverIp
}

#获取当前脚本路径
#不能用pwd，如果在a脚本中使用pwd获取当前脚本路径，在b脚本中调用a脚本，这时pwd获取的是b脚本的路径。
getCurrentFilePath(){
    curPath=$(dirname $(readlink -f "$0"))
    echo $curPath 
}


#对文件的每一行，查看这一行是否包含源字符串，如果包含则把这一行的源字符串替换为目标字符串，如果不包含则往文件末尾添加
#$1 源字符串
#$2 目标字符串
#$3 文件路径
findAndReplaceOrAdd(){
    source=${1//\//\\\/}  #把'/'替换为'\/'
    target=${2//\//\\\/}
    if [[ $(cat $3 | grep $source) != "" ]]; then
        sed -i "s/$source/$target/g" $3
    else
        echo $target >> $3
    fi
}