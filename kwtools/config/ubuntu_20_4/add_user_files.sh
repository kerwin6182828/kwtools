#!/bin/bash
#########################################################################
# File Name: init_ubuntu_sys.sh
# Author: kerwin
# mail: kerwin19950830@gmail.com
# Created Time: 2021年10月16日
# Function: Auto init VPS include install necessary tool , create user and add user config
#########################################################################
set -u


# 定义配置内容
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# 1. 用户名
user_name=${USER}

# 2. 需要部署项目的github路径
project_address_array=(
    "https://github.com/Adolf-L/kw_arb.git" # kw_arb项目
    "https://github.com/Adolf-L/lc_arb.git" # lc_arb项目
    "https://github.com/Adolf-L/lcquant.git" # lcquant项目
)
github_sign="https://kerwin19950830%40gmail.com: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@github.com"

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# 初始化一些变量
init_script(){
    echo '=========================================================================='
    echo '==================================STRAT==================================='
    echo '=========================================================================='

    # python版本
    python_version=`python3 --version | grep -P -o '3.\d+'` # 3.8 or 3.9

    # 用于打印的颜色
    red='\033[0;31m'
    green='\033[0;32m'
    yellow='\033[0;33m'
    plain='\033[0m'
}

# 添加用户的配置信息&项目代码
add_user_config_and_project(){
    echo '----------------------------------------------------------------------------------'
    echo -e "${yellow}[INFO]:${plain} Start to add ${user_name}'s config and project"
    echo '----------------------------------------------------------------------------------'

    home="/home/${user_name}"
    # 添加.bashrc
    wget -O .bashrc "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_20_4/bashrc"

    # 添加.vimrc
    # wget -O .vimrc "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_20_4/vimrc"
    # source .vimrc

    # 部署项目代码
    git config --global credential.helper store # 会在本地生成'.gitconfig'文件
    echo "${github_sign}" >> .git-credentials
    if [ ${user_name} == 'kerwin' ]; then
        project_branch="kw-dev"
    fi
    if [ ${user_name} == 'bigluo' ]; then
        project_branch="bl-dev"
    fi
    echo -e "${yellow}[INFO]:${plain} 正在部署项目代码..."
    for project_address in ${project_address_array[@]}; do
        project_name=`echo ${project_address} | sed 's/.*\/\(.*\)\.git/\1/g'`
        git clone -b ${project_branch} ${project_address} # (个人分支)
        pip install -r ${project_name}/requirements.txt --user pkg # 安装项目依赖库 (在用户环境下安装python库) (用户之间相互独立, 环境干净)
        echo "${home}/${project_name}" >> /usr/lib/python3/dist-packages/python.pth # 添加到python默认搜索路径

    done
    [ $? -ne 0 ] && echo -e "${red}[ERROR]:${plain} Deploy project failed!"

    # 软链接:
    ln -s "${home}/.local/lib/python${python_version}/site-packages" ~/site-packages

    # 添加用户个人python库
    echo -e "${yellow}[INFO]:${plain} 正在下载 kwtools ..."
    pip install kwtools --user pkg

}


# 执行函数
init_script
add_user_config_and_project
source .bashrc
source .vimrc



echo '=========================================================================='
echo '===================================END===================================='
echo '=========================================================================='
