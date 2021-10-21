#!/bin/bash
#########################################################################
# File Name: init_ubuntu.sh (recommend: ubuntu 21.04)
# Author: kerwin
# mail: kerwin19950830@gmail.com
# Created Time: 2021年10月16日
# Function: Auto init VPS include install necessary tool , create user and add user config
# Notes: recommend to use 'source init_ubuntu.sh' to execute.
#########################################################################
set -u


# 定义配置内容
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# 1. 需要通过apt下载的工具
necessary_tool='sudo curl wget vim git python3 ipython3 docker.io python3-pip'

# 2. 用户信息
user_name="kerwin"
passwd=15168201914

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# 初始化一些变量
init_script(){
    echo '=========================================================================='
    echo '==================================STRAT==================================='
    echo '=========================================================================='

    # 此脚本必须是root用户来执行, 否则退出登录
    [[ $EUID -ne 0 ]] && echo -e "${red}[ERROR]:${plain} This script must be run as root!" && exit

    # 获取linux的发行版本
    if [ -f /etc/redhat-release ]; then
        release="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    fi

    # python版本
    python_version=`python3 --version | grep -P -o '3.\d+'` # 3.8 or 3.9

    # 用于打印的颜色
    red='\033[0;31m'
    green='\033[0;32m'
    yellow='\033[0;33m'
    plain='\033[0m'
}


# 修改一些系统配置
update_system_config(){
    # 1. 修改海外服务器时区设置
        # i. 从UTC时间改为东八区
    mv /etc/localtime /etc/localtime.bak
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
        # ii. 修改timezone的标记
    cat /etc/timezone
    echo Asia/Shanghai > /etc/timezone

}


# 下载系统基础工具
install_necessary_tool(){
    echo '----------------------------------------------------------------------------------'
    echo -e "${yellow}[INFO]:${plain} Start to install ${necessary_tool}"
    echo '----------------------------------------------------------------------------------'

    if [ $release == 'ubuntu' ]; then
        apt update
        apt -y install ${necessary_tool}
    else
        echo -e "${red}[ERROR]:${plain} OS '${release}' is not be supported, please change OS to 'Ubuntu' and try again."
    fi
}

# 开启docker服务
start_docker_server(){
    echo '----------------------------------------------------------------------------------'
    echo -e "${yellow}[INFO]:${plain} 正在部署docker服务..."
    echo '----------------------------------------------------------------------------------'
    docker run -d --name lc_rabbitmq --restart always  -p 5672:5672 -p 15672:15672 rabbitmq:3-management
    mkdir -p /data/db/mongo
    docker run -d --name lc_mongodb --restart always -e MONGO_INITDB_ROOT_USERNAME=lc -e MONGO_INITDB_ROOT_PASSWORD=lc123456 -v /data/db/mongo:/data/db -p 27017:27017 mongo
    docker run -d --name lc_redis --restart always -p:6379:6379 redis
}

# 创建用户
create_user(){
    echo '----------------------------------------------------------------------------------'
    echo -e "${yellow}[INFO]:${plain} Start to add user '${user_name}'"
    echo '----------------------------------------------------------------------------------'

    # 若系统已经有该用户名, 则先删除再重新创建:
    if cat /etc/passwd | grep ${user_name}; then
        echo -e "${yellow}[INFO]: ${plain}用户'${user_name}'已经被创建, 尝试删除后重建..."
        userdel ${user_name} # 删除用户 (系统会自动在/etc/passwd文件中将其删除)
    fi

    # 为用户创建家目录, 并且指定使用bash shell
    useradd -m -s /bin/bash ${user_name}
    # 为用户设置密码
    echo -e "${passwd}\n${passwd}" | passwd ${user_name}
    # 异常处理:
    if [ $? != 0 ]; then # 上面密码设置不成功返回的$?状态码为10
        # 若密码设置不成功, 则打印错误, 并返回
        echo -e "${red}[ERROR]: ${plain}用户'${user_name}'的密码: '${passwd}' 创建失败, 请设置更复杂的密码..."
        return 10 # 同上 (即: 从系统中得到的状态码)
    fi
    # 赐予用户sudo神力, 且无须密码
    if ! cat /etc/sudoers | grep -Eqi "${user_name}"; then
        # 如果sudoers中没有授予该用户root免密权限, 则重定向追加
        echo "${user_name} ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    fi
    # su - ${user_name} -c "sudo touch tt.log" # 测试使用: 切换用户并跳转到用户家目录, 并创建一个文件后再退出该用户;
}




# 执行函数
init_script
update_system_config
install_necessary_tool
start_docker_server
create_user


echo '=========================================================================='
echo '===================================END===================================='
echo '=========================================================================='
