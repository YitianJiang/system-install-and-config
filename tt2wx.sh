#字节小程序转微信小程序 
#字节的小程序太坑爹了
#choose video 卡住，没法进入 fail success complete 中任意一个
#官方chooseVideo demo 现在无法打开 头条无法调试 抖音才能调试
#调试器页面unload无法触发
#npm install 一个包后 idea编译失败 得重新启动才能正常编译
#windows下terminal无法打开
#偶尔调试器一个页面字体大小出现异常

filelist=$(find /root/circle-fe-small-app -name "*.ttml")
for file in $filelist
do
    rename .ttml .wxml $file
done

filelist=$(find /root/circle-fe-small-app -name "*.ttss")
for file in $filelist
do
    rename .ttss .wxss $file
done