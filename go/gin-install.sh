if [[ `go version | grep go` == "" ]];then
  echo "please install go"
  exit 1
fi
#关掉模块支持 否则gin会安装在mod目录下，demo运行时提示找不到
go env -w GO111MODULE=off
go get -u github.com/gin-gonic/gin