#!/bin/bash
while true; do
    output_script_status=`ps -ef | grep k99_导出对冲检查表.py | grep -v "grep" | wc -l`

    if [ ${output_script_status} == 0 ]; then
        datetime=$(date +"%Y-%m-%d %H:%M:%S")
        echo "[${datetime}] 正在导出'对冲检查表'....."
        nohup python3 -u ~/kw_arb/kw_arb/v2_5/scripts/k99_导出对冲检查表.py > ~/log/hedge.log &
        sleep 30 # 睡眠30秒 (等待导出所有表格)
    fi

    datetime=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "[${datetime}] 睡眠4小时, 等待下次导出task....\n\n"
    sleep $((60*60*4)) # 睡眠4个小时 (相当于每4个小时导出1份'对冲检查表')
done
