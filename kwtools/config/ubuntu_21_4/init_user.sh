#!/bin/bash
#########################################################################
# File Name: init_user.sh (recommend: ubuntu 21.04)
# Author: kerwin
# mail: kerwin19950830@gmail.com
# Created Time: 2021年10月16日
# Function: Auto init VPS include install necessary tool , create user and add user config
# Notes: recommend to use 'source init_user.sh' to execute.
#########################################################################
set -u



# 定义配置内容
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# 需要部署项目的github路径
project_address_array=(
    "https://github.com/Adolf-L/kw_arb.git" # kw_arb项目
    "https://github.com/Adolf-L/lc_arb.git" # lc_arb项目
    "https://github.com/Adolf-L/lcquant.git" # lcquant项目
)
# Personal access tokens
PAT="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" # Required
github_sign="https://kerwin19950830%40gmail.com:${PAT}@github.com"

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# 初始化一些变量
init_script(){
    echo '=========================================================================='
    echo '==================================STRAT==================================='
    echo '=========================================================================='

    # 1. 用户
    user_name=${USER} # eg: kerwin
    home_path="/home/${user_name}"

    # 2. python
    python_version=`python3 --version | grep -P -o '3.\d+'` # eg: 3.8 or 3.9
    python_site_packages_path="${home_path}/.local/lib/python${python_version}/site-packages" # eg: /home/kerwin/.local/lib/python3.9/site-packages

    # 3. 打印颜色
    red='\033[0;31m'
    green='\033[0;32m'
    yellow='\033[0;33m'
    plain='\033[0m'
}

# 添加用户的配置信息
add_user_config(){
    echo '----------------------------------------------------------------------------------'
    echo -e "${yellow}[INFO]:${plain} Start to add ${user_name}'s config"
    echo '----------------------------------------------------------------------------------'

    # 进入家目录
    cd ${home_path}

    # 添加.bashrc
    wget -O .bashrc "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_21_4/bashrc" && \
    source .bashrc

    # 添加.vimrc
    wget -O .vimrc "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_21_4/vimrc" && \
    source .vimrc

}

# 添加用户的python库
install_python_packages(){
    echo '----------------------------------------------------------------------------------'
    echo -e "${yellow}[INFO]:${plain} Start to install ${user_name}'s python packages"
    echo '----------------------------------------------------------------------------------'

    # 添加用户个人python库
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    # 1. kwtools
    echo -e "${yellow}[INFO]:${plain} Installing kwtools....."
    pip install kwtools --user pkg

    # 2. talib # 耗时较长 (about 5min)
    if ! pip list | grep -o "TA-Lib"; then
        echo -e "${yellow}[INFO]:${plain} Installing talib....."
        wget "http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz"
        tar -xzvf ta-lib-0.4.0-src.tar.gz
        cd ta-lib
        ./configure --prefix=/usr
        make
        sudo make install # 这步必须要sudo权限
        sudo apt upgrade
        pip3 install Ta-Lib --user pkg
        cd ${home_path}
        rm -rf ta-lib* # 删除安装包
    fi
    # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    # 软链接:
    ln -s "${python_site_packages_path}" ~/site-packages
}


# 部署用户的项目代码
add_user_project(){
    echo '----------------------------------------------------------------------------------'
    echo -e "${yellow}[INFO]:${plain} Start to add ${user_name}'s project"
    echo '----------------------------------------------------------------------------------'

    # 添加github的PAT
    git config --global credential.helper store && \ # 会在本地生成'.gitconfig'文件
    echo "${github_sign}" >> "${home_path}/.git-credentials" # 添加 PAT (私有库需要)

    # 项目分支名
    if [ ${user_name} == 'kerwin' ]; then
        project_branch="kw-dev"
    fi
    if [ ${user_name} == 'bigluo' ]; then
        project_branch="bl-dev"
    fi

    # 部署github项目代码
    echo -e "${yellow}[INFO]:${plain} 正在部署项目代码..."
    for project_address in ${project_address_array[@]}; do
        project_name=`echo ${project_address} | sed 's/.*\/\(.*\)\.git/\1/g'`
        git clone -b ${project_branch} ${project_address} # (个人分支)
        pip install -r ${project_name}/requirements.txt --user pkg # 安装项目依赖库 (在用户环境下安装python库) (用户之间相互独立, 环境干净)
        echo "${home_path}/${project_name}" >> "${python_site_packages_path}/python.pth" # 添加到python默认搜索路径

    done

    # 部署异常报错
    [ $? -ne 0 ] && echo -e "${red}[ERROR]:${plain} Deploy project failed!"
}




# 执行函数
init_script
add_user_config
install_python_packages
add_user_project




# source .vimrc
# source .bashrc



echo '=========================================================================='
echo '===================================END===================================='
echo '=========================================================================='
