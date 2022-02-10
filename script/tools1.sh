#!/bin/bash
[[ $(id -u) != 0 ]] && echo -e "请使用root权限运行安装脚本" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "此脚本不支持该系统" && exit 1
fi

install() {
    if [ -d "/root/mining_proxy" ]; then
        echo -e "您已安装了该软件,如果确定没有安装,请输入rm -rf /root/mining_proxy" && exit 1
    fi
    if screen -list | grep -q "miningProxy"; then
        echo -e "检测到您已启动了miningProxy,请关闭后再安装" && exit 1
    fi

    $cmd update -y
    $cmd install curl wget screen -y
    mkdir /root/mining_proxy

    echo "请选择V3.0.3版本还是V4.0.0版本"
    echo "  1、V3.0.3"
    echo "  2、V4.0.0T8"
    read -p "$(echo -e "请输入[1-2]：")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/zrx830/mining_proxy/main/mining_proxy_linux -O /root/mining_proxy/miningProxy
#        wget https://cdn.jsdelivr.net/gh/zrx830/mining_proxy/main/mining_proxy_linux -O /root/mining_proxy/miningProxy
        ;;
    2)
        wget https://raw.githubusercontent.com/zrx830/mining_proxy/main/mining_proxy_linux -O /root/mining_proxy/minerProxy
#        wget https://cdn.jsdelivr.net/gh/zrx830/mining_proxy/main/mining_proxy_linux -O /root/miner_proxy/miningProxy
        ;;
    *)
        echo "请输入正确的数字"
        ;;
    esac
    chmod 777 /root/mining_proxy/miningProxy

    wget https://raw.githubusercontent.com/zrx830/mining_proxy/tree/main/script/run.sh -O /root/mining_proxy/run.sh
#    wget https://cdn.jsdelivr.net/gh/zrx830/mining_proxy/tree/main/script/run.sh -O /root/mining_proxy/run.sh
    chmod 777 /root/mining_proxy/run.sh
    echo "如果没有报错则安装成功"
    echo "正在启动..."
    screen -dmS miningProxy
    sleep 0.2s
    screen -r miningProxy -p 0 -X stuff "cd /root/mining_proxy"
    screen -r miningProxy -p 0 -X stuff $'\n'
    screen -r miningProxy -p 0 -X stuff "./run.sh"
    screen -r miningProxy -p 0 -X stuff $'\n'
    sleep 1s
    cat /root/mining_proxy/config.yml
    echo "请记录您的token和端口 并打开 http://服务器ip:端口 访问web服务进行配置"
    echo "已启动web后台 您可运行 screen -r miningProxy 查看程序输出"
}

uninstall() {
    read -p "是否确认删除miningProxy[yes/no]：" flag
    if [ -z $flag ]; then
        echo "输入错误" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
            screen -X -S miningProxy quit
            rm -rf /root/mining_proxy
            echo "卸载miningProxy成功"
        fi
    fi
}

update() {
    if screen -list | grep -q "miningProxy"; then
        screen -X -S miningProxy quit
    fi
    rm -rf /root/mining_proxy/miningProxy
    echo "请选择V3.0.3版本还是V4.0.0版本"
    echo "  1、V3.0.3"
    echo "  2、V4.0.0T7"
    read -p "$(echo -e "请输入[1-2]：")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/zrx830/mining_proxy/main/mining_proxy_linux -O /root/mining_proxy/miningProxy
#        wget https://cdn.jsdelivr.net/gh/zrx830/mining_proxy/main/mining_proxy_linux -O /root/mining_proxy/miningProxy
        ;;
    2)
        wget https://raw.githubusercontent.com/zrx830/mining_proxy/main/mining_proxy_linux -O /root/mining_proxy/miningProxy
#        wget https://cdn.jsdelivr.net/gh/zrx830/mining_proxy/main/mining_proxy_linux -O /root/mining_proxy/miningProxy
        ;;
    *)
        echo "请输入正确的数字"
        ;;
    esac
    chmod 777 /root/mining_proxy/miningProxy

    echo "v3和v4版本配置文件不通用,如果您为v3升级为v4或v4回退至v3,请删除配置文件"
    read -p "是否删除配置文件[yes/no]：" flag
    if [ -z $flag ]; then
        echo "输入错误" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
            rm -rf /root/mining_proxy/config.yml
            echo "删除配置文件成功"
        fi
    fi
    screen -dmS miningProxy
    sleep 0.2s
    screen -r miningProxy -p 0 -X stuff "cd /root/mining_proxy"
    screen -r miningProxy -p 0 -X stuff $'\n'
    screen -r miningProxy -p 0 -X stuff "./run.sh"
    screen -r miningProxy -p 0 -X stuff $'\n'

    sleep 1s
    cat /root/mining_proxy/config.yml
    echo "请记录您的token和端口 并打开 http://服务器ip:端口 访问web服务进行配置"
    echo "您可运行 screen -r miningProxy 查看程序输出"
}

start() {
    if screen -list | grep -q "miningProxy"; then
        echo -e "miningProxy已启动,请勿重复启动" && exit 1
    fi
    screen -dmS miningProxy
    sleep 0.2s
    screen -r miningProxy -p 0 -X stuff "cd /root/mining_proxy"
    screen -r miningProxy -p 0 -X stuff $'\n'
    screen -r miningProxy -p 0 -X stuff "./run.sh"
    screen -r miningProxy -p 0 -X stuff $'\n'

    echo "miningProxy已启动"
    echo "您可以使用指令screen -r miningProxy查看程序输出"
}

restart() {
    if screen -list | grep -q "miningProxy"; then
        screen -X -S miningProxy quit
    fi
    screen -dmS miningProxy
    sleep 0.2s
    screen -r miningProxy -p 0 -X stuff "cd /root/mining_proxy"
    screen -r miningProxy -p 0 -X stuff $'\n'
    screen -r miningProxy -p 0 -X stuff "./run.sh"
    screen -r miningProxy -p 0 -X stuff $'\n'

    echo "miningProxy 重新启动成功"
    echo "您可运行 screen -r miningProxy 查看程序输出"
}

stop() {
    if screen -list | grep -q "miningProxy"; then
        screen -X -S miningProxy quit
    fi
    echo "miningProxy 已停止"
}

change_limit(){
    num="n"
    if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root soft nofile 102400" >>/etc/security/limits.conf
        num="y"
    fi

    if [[ "$num" = "y" ]]; then
        echo "连接数限制已修改为102400,重启服务器后生效"
    else
        echo -n "当前连接数限制："
        ulimit -n
    fi
}

check_limit(){
    echo -n "当前连接数限制："
    ulimit -n
}

echo "======================================================="
echo "zrx830的miningProxy 一键工具"
echo "  1、安装(默认安装到/root/miningProxy)"
echo "  2、卸载"
echo "  3、更新"
echo "  4、启动"
echo "  5、重启"
echo "  6、停止"
echo "  7、解除linux系统连接数限制(需要重启服务器生效)"
echo "  8、查看当前系统连接数限制"
#echo "  9、配置开机启动"
echo "======================================================="
read -p "$(echo -e "请选择[1-8]：")" choose
case $choose in
1)
    install
    ;;
2)
    uninstall
    ;;
3)
    update
    ;;
4)
    start
    ;;
5)
    restart
    ;;
6)
    stop
    ;;
7)
    change_limit
    ;;
8)
    check_limit
    ;;
*)
    echo "输入错误请重新输入！"
    ;;
esac
