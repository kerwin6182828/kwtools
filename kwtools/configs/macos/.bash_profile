
# shell命令相关
alias ll="ls -alh"

# python 的相关配置
alias python="/usr/local/bin/python3"
alias ipython="/usr/local/bin/ipython3"
alias pip="/usr/local/bin/pip3"
alias p="ipython"
alias i="ipython"

# brew 的相关配置
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
alias start="brew services start"
alias restart="brew services restart"
alias stop="brew services stop"
alias list="brew services list"

# mongo 的相关配置
alias local_mongo="mongo -ukerwin -pkw618"
#alias remote_mongo="mongo 120.55.63.193:27017 -ukerwin -pkw618 --authenticationDatabase 'admin' "

# mysql 的相关配置
alias local_mysql="mysql -uroot -pkw618"
alias remote_mysql="mysql -h120.55.63.193 -uroot -pkw618"

# go 的相关配置
export GOPATH="/Users/kerwin/go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOBIN}"

# nvim
alias v="nvim"


# 代理设置
# =======================================
export PROXY="http://127.0.0.1:7890"
# 终端使用代理
alias open_proxy="export http_proxy=${PROXY}; export https_proxy=${PROXY}"
# 终端禁用代理
alias close_proxy='unset http_proxy; unset https_proxy'


# 设置文件同时开启的最大上限
ulimit -n 65535

# 快捷命令
alias t="tail -f -n 300"
