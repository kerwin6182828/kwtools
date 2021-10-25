#!/bin/bash
while true; do
    market_module_status=`ps -ef | grep market.py | grep -v "grep" | wc -l`
    calculate_module_status=`ps -ef | grep calculate.py | grep -v "grep" | wc -l`
    monitor_module_status=`ps -ef | grep monitor.py | grep -v "grep" | wc -l`

    # 1. market
    if [ ${market_module_status} == 0 ]; then
        datetime=$(date +"%Y-%m-%d %H:%M:%S")
        echo "[${datetime}] 检测到'market'模块已经终止, 重新启动中..."
        nohup python3 -u /home/kerwin/kw_arb/kw_arb/v2_5/market.py > ~/log/market.log &
        sleep 2
    fi

    # 2. calculate
    if [ ${calculate_module_status} == 0 ]; then
        datetime=$(date +"%Y-%m-%d %H:%M:%S")
        echo "[${datetime}] 检测到'calculate'模块已经终止, 重新启动中..."
        nohup python3 -u /home/kerwin/kw_arb/kw_arb/v2_5/calculate.py > ~/log/calculate.log &
        sleep 2
    fi

    # 3. monitor
    if [ ${monitor_module_status} == 0 ]; then
        datetime=$(date +"%Y-%m-%d %H:%M:%S")
        echo "[${datetime}] 检测到'monitor'模块已经终止, 重新启动中..."
        nohup python3 -u /home/kerwin/kw_arb/kw_arb/v2_5/monitor.py > ~/log/monitor.log &
        sleep 2
    fi

    datetime=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[${datetime}] 3个模块都正常执行中...."
    sleep 10 # 每隔10秒监控一次
done
