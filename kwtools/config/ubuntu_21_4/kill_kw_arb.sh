# kill所有后台启动的进程
kill `ps -ef | grep ensure_run.sh | grep -v "grep" | awk '{print $2}'`
kill `ps -ef | grep market.py | grep -v "grep" | awk '{print $2}'`
kill `ps -ef | grep calculate.py | grep -v "grep" | awk '{print $2}'`
kill `ps -ef | grep account.py | grep -v "grep" | awk '{print $2}'`
kill `ps -ef | grep signals.py | grep -v "grep" | awk '{print $2}'`
kill `ps -ef | grep quotation.py | grep -v "grep" | awk '{print $2}'`
kill `ps -ef | grep risk.py | grep -v "grep" | awk '{print $2}'`
kill `ps -ef | grep persistence.py | grep -v "grep" | awk '{print $2}'`
