#!/bin/bash

# 定义配置内容
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# 需要监控运行的模块
run_modules=(
    "market"
    "calculate"
    "account"
    "signal"
    # "quotation"
    # "risk"
    "output_fi"
)
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


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
    market_module_pid=`ps -ef | grep market.py | grep -v "grep" | awk '{print $2}'`
    calculate_module_pid=`ps -ef | grep calculate.py | grep -v "grep" | awk '{print $2}'`
    account_module_pid=`ps -ef | grep account.py | grep -v "grep" | awk '{print $2}'`
    signal_module_pid=`ps -ef | grep signals.py | grep -v "grep" | awk '{print $2}'`
    quotation_module_pid=`ps -ef | grep quotation.py | grep -v "grep" | awk '{print $2}'`
    risk_module_pid=`ps -ef | grep risk.py | grep -v "grep" | awk '{print $2}'`
    output_fi_pid=`ps -ef | grep output_fi_prdl.py | grep -v "grep" | awk '{print $2}'`

    for module in ${run_modules[@]}; do
        echo -e "正在监控 ${module} 模块..."

        # 1. market模块
        if [[ ${module} == 'market' && ! ${market_module_pid} ]]; then
            datetime=$(date +"%Y-%m-%d %H:%M:%S")
            echo -e "[${datetime}] 检测到'market'模块已经终止, 重新启动中...\n\n"
            nohup python3 -u "${kw_arb_path}/v2_5/market.py" > ~/log/market.log &
            sleep 2
        fi

        # 2. calculate模块
        if [[ ${module} == 'calculate' && ! ${calculate_module_pid} ]]; then
            datetime=$(date +"%Y-%m-%d %H:%M:%S")
            echo -e "[${datetime}] 检测到'calculate'模块已经终止, 重新启动中...\n\n"
            nohup python3 -u "${kw_arb_path}/v2_5/calculate.py" > ~/log/calculate.log &
            sleep 2
        fi

        # 3. account模块
        if [[ ${module} == 'account' && ! ${account_module_pid} ]]; then
            datetime=$(date +"%Y-%m-%d %H:%M:%S")
            echo -e "[${datetime}] 检测到'account'模块已经终止, 重新启动中...\n\n"
            nohup python3 -u "${kw_arb_path}/v2_5/account.py" > ~/log/account.log &
            sleep 2
        fi

        # 4. signal模块
        if [[ ${module} == 'signal' && ! ${signal_module_pid} ]]; then
            datetime=$(date +"%Y-%m-%d %H:%M:%S")
            echo -e "[${datetime}] 检测到'signal'模块已经终止, 重新启动中...\n\n"
            nohup python3 -u "${kw_arb_path}/v2_5/signals.py" > ~/log/signal.log &
            sleep 2
        fi

        # 5. quotation模块
        if [[ ${module} == 'quotation' && ! ${quotation_module_pid} ]]; then
            datetime=$(date +"%Y-%m-%d %H:%M:%S")
            echo -e "[${datetime}] 检测到'quotation'模块已经终止, 重新启动中...\n\n"
            nohup python3 -u "${kw_arb_path}/v2_5/quotation.py" > ~/log/quotation.log &
            sleep 2
        fi

        # 6. risk模块
        if [[ ${module} == 'risk' && ! ${risk_module_pid} ]]; then
            datetime=$(date +"%Y-%m-%d %H:%M:%S")
            echo -e "[${datetime}] 检测到'risk'模块已经终止, 重新启动中...\n\n"
            nohup python3 -u "${kw_arb_path}/v2_5/risk.py" > ~/log/risk.log &
            sleep 2
        fi

        # 7. output_financial_statements脚本
        if [[ ${module} == 'output_fi' && ! ${output_fi_pid} ]]; then
            datetime=$(date +"%Y-%m-%d %H:%M:%S")
            echo -e "[${datetime}] 检测到'output'脚本已经终止, 重新启动中...\n\n"
            nohup python3 -u "${kw_arb_path}/v2_5/scripts/output_fi_prdl.py" > ~/log/output_fi.log &
            sleep 2
        fi
    done


    datetime=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[${datetime}] ${#run_modules[@]}个模块都正常执行中...."
    sleep 60 # 每隔60秒监控一次
done
