#!/bin/bash

# 导入工具库
source ~/kwtools.sh

# 初始化信息
system_type=`uname` # Darwin or Linux
user_name=${USER}
if [ ${system_type} == 'Linux' ]; then
    home_path="/home/${user_name}"
    kw_arb_path="${home_path}/kw_arb/kw_arb"
elif [ ${system_type} == 'Darwin' ]; then
    home_path="/Users/${user_name}"
    kw_arb_path="${home_path}/box/kw_arb/kw_arb"
fi

# 验证路径是否存在
if [ ! -e ${kw_arb_path} ]; then
    echo "路径:'${kw_arb_path}'不存在, 退出脚本程序..."
    exit 1
fi

# 确保有'~/log'目录
ensure_file ~/log folder


# 开始循环监控
while true; do
    market_module_status=`ps -ef | grep market.py | grep -v "grep" | wc -l`
    calculate_module_status=`ps -ef | grep calculate.py | grep -v "grep" | wc -l`
    monitor_module_status=`ps -ef | grep monitor.py | grep -v "grep" | wc -l`
    output_script_status=`ps -ef | grep output_fi_prdl.py | grep -v "grep" | wc -l`

    # 1. market模块
    if [ ${market_module_status} == 0 ]; then
        datetime=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "[${datetime}] 检测到'market'模块已经终止, 重新启动中...\n\n"
        nohup python3 -u "${kw_arb_path}/v2_5/market.py" > ~/log/market.log &
        sleep 2
    fi

    # 2. calculate模块
    if [ ${calculate_module_status} == 0 ]; then
        datetime=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "[${datetime}] 检测到'calculate'模块已经终止, 重新启动中...\n\n"
        nohup python3 -u "${kw_arb_path}/v2_5/calculate.py" > ~/log/calculate.log &
        sleep 2
    fi

    # 3. monitor模块
    if [ ${monitor_module_status} == 0 ]; then
        datetime=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "[${datetime}] 检测到'monitor'模块已经终止, 重新启动中...\n\n"
        nohup python3 -u "${kw_arb_path}/v2_5/monitor.py" > ~/log/monitor.log &
        sleep 2
    fi

    # 4. output_financial_statements脚本
    if [ ${output_script_status} == 0 ]; then
        datetime=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "[${datetime}] 检测到'output'脚本已经终止, 重新启动中...\n\n"
        nohup python3 -u "${kw_arb_path}/v2_5/scripts/output_fi_prdl.py" > ~/log/output.log &
        sleep 2
    fi


    datetime=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[${datetime}] 4个模块都正常执行中...."
    sleep 10 # 每隔10秒监控一次
done
