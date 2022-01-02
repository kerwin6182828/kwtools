
# shell命令相关
alias ll="ls -al"

# brew 的相关配置
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export PATH=$PATH:/usr/local/Cellar/python/3.7.6_1/bin

# python 的相关配置
alias python="/usr/local/bin/python3"
alias ipython="/usr/local/bin/ipython3"
alias pip="/usr/local/bin/pip3"
alias p="ipython"
alias i="ipython"

# brew 的相关配置
alias start="brew services start"
alias restart="brew services restart"
alias stop="brew services stop"
alias list="brew services list"

# mongo 的相关配置
alias local_mongo="mongo -ukerwin -pkw618"
alias remote_mongo="mongo 120.55.63.193:27017 -ukerwin -pkw618 --authenticationDatabase 'admin' "
#alias mongod="sudo mongod --dbpath=/Users/kerwin/data/db"

# mysql 的相关配置
alias local_mysql="mysql -uroot -pkw618"
alias remote_mysql="mysql -h120.55.63.193 -uroot -pkw618"

# go 的相关配置
# PATH表示: 添加进环境变量 (在任何路径下都可以访问到该路径下的命令)
export GOPATH=/Users/kerwin/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# nvim
alias v="nvim"


# 代理设置
# =======================================
url=http://127.0.0.1:7890
# 如果代理失效的话直接运行 poff 即可断开 proxy
alias poff='unset http_proxy;unset https_proxy'
# 快捷方式打开
alias pon='export http_proxy=$url; export https_proxy=$url'


# 设置文件同时开启的最大上限
ulimit -n 65535


# 快捷命令
alias t="tail -f -n 300"
