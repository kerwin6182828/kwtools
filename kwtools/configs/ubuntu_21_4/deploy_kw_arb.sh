# << 服务器的自动化部署流程 >>
# ===========================================================================================================
# ===========================================================================================================

# 1. 下载'初始化ubunut'的shell脚本, 并执行
wget -O init_ubuntu.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/configs/ubuntu_21_4/init_ubuntu.sh"
vim init_ubuntu.sh # 1. 修改配置内容(用户信息)
chmod +x init_ubuntu.sh
source init_ubuntu.sh


# 2. 切换用户
su kerwin
cd


# 3. 下载'初始化user'的shell脚本, 并执行
wget -O init_user.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/configs/ubuntu_21_4/init_user.sh"
vim init_user.sh # 修改配置内容 (必填: PAT)
chmod +x init_user.sh
source init_user.sh
# 本地端操作 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
remote_ip="45.63.120.150" # 需要更新ip
remote_user="kerwin" # 需要更新用户名
ssh-copy-id ${remote_user}@${remote_ip}
# 输入用户密码, 之后就可以免密登录了


# 4. 上传 kw_arb项目的`配置文件`
# 本地端操作 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# 1. settings.py
scp -r ~/box/kw_arb/kw_arb/configs/settings.py ${remote_user}@${remote_ip}:~/kw_arb/kw_arb/configs/settings.py
# 2. secret.py
scp -r ~/box/kw_arb/kw_arb/src/modules/account_modules/secret.py ${remote_user}@${remote_ip}:~/kw_arb/kw_arb/src/modules/account_modules/secret.py
# 3. m_config.py
scp -r ~/box/kw_arb/market_monitor/src/monitors/m_config.py ${remote_user}@${remote_ip}:~/kw_arb/market_monitor/src/monitors/m_config.py
# 4. operate.py
scp -r ~/box/kw_arb/kw_arb/src/modules/operate.py ${remote_user}@${remote_ip}:~/kw_arb/kw_arb/src/modules/operate.py
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# 软链接: (远程端操作)
cd
ln -s ~/kw_arb/kw_arb/configs/settings.py ~/settings.py
ln -s ~/kw_arb/market_monitor/src/monitors/m_config.py ~/m_config.py
ln -s ~/kw_arb/kw_arb/src/modules/operate.py ~/operate.py
# 执行操盘:
python operate.py


# 5. 添加数据库索引
# ===============================================
# i. 进入mongo
sudo docker exec -it lc_mongodb mongo -ulc -plc123456
# ii. 切换数据库
use lc_market_data
db.dropDatabase();
use lc_account_data
db.dropDatabase();
# iii. 创建索引
use lc_market_data
db.funding_rate.createIndex({"lc_symbol":1, "datetime":1}, {"unique":true})
db.open_vspread_rate.createIndex({"spread_symbol":1, "datetime":1}, {"unique":true})
db.close_vspread_rate.createIndex({"spread_symbol":1, "datetime":1}, {"unique":true})
db.funding_rate.getIndexes();
db.open_vspread_rate.getIndexes();
db.close_vspread_rate.getIndexes();

use lc_account_data
db.sum.createIndex({"user":1, "datetime":1}, {"unique":true})
db.hedge.createIndex({"user":1, "asset":1, "datetime":1}, {"unique":true})
db.u_s_pos.createIndex({"user":1, "symbol":1, "datetime":1}, {"unique":true})
db.u_l_pos.createIndex({"user":1, "symbol":1, "datetime":1}, {"unique":true})
db.u_both_pos.createIndex({"user":1, "symbol":1, "datetime":1}, {"unique":true})
db.assets.createIndex({"user":1, "asset":1, "datetime":1}, {"unique":true})
db.uswap_risk.createIndex({"user":1, "datetime":1}, {"unique":true})
db.cro_risk.createIndex({"user":1, "datetime":1}, {"unique":true})
db.iso_risk.createIndex({"user":1, "symbol":1, "datetime":1}, {"unique":true})
db.sum.getIndexes();
db.hedge.getIndexes();
db.u_s_pos.getIndexes();
db.u_l_pos.getIndexes();
db.u_both_pos.getIndexes();
db.assets.creatgetIndexes();
db.uswap_risk.getIndexes();
db.cro_risk.getIndexes();
db.iso_risk.getIndexes();

exit


# 6. 执行kw_arb项目
cd
# 导入工具库
wget -O kwtools.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/configs/ubuntu_21_4/kwtools.sh"
chmod +x ~/kwtools.sh
source ~/kwtools.sh
# 启动项目的入口脚本 (使用bash脚本, 一键启动所有模块在后台执行, 并将日志文件输出到~/log目录下)
wget -O ensure_run.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/configs/ubuntu_21_4/ensure_run.sh"
wget -O show_kw_arb.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/configs/ubuntu_21_4/show_kw_arb.sh"
wget -O kill_kw_arb.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/configs/ubuntu_21_4/kill_kw_arb.sh"
chmod +x ~/ensure_run.sh
chmod +x ~/show_kw_arb.sh
chmod +x ~/kill_kw_arb.sh
ensure_file ~/log folder
nohup ~/ensure_run.sh > ~/log/ensure_run.log & # 如果用nohup, 相当于就是用bash执行shell脚本了(不需要再加source了)
# 还需要启动一个交互的窗口 (smm)
# (进入iterm)
# from kw_arb import *
# sg = init_smm(log_level=10) # 主线程的控制权在用户手中! (便于交互)
# 然后就可以通过set_mu, pause_mu, get_table, get_orders 来操作交互了
# (后期需要把这部分内容放到一个screen中! 这样可以让iterm中的程序内容后台保留)


# 查看程序是否正在执行
source show_kw_arb.sh
# ps aux | grep ensure_run.sh
# ps aux | grep market.py
# ps aux | grep calculate.py
# ps aux | grep account.py
# ps aux | grep signals.py
# ps aux | grep quotation.py
# ps aux | grep risk.py
# ps aux | grep persistence.py


# kill所有后台启动的进程
source kill_kw_arb.sh
# kill `ps -ef | grep ensure_run.sh | grep -v "grep" | awk '{print $2}'`
# kill `ps -ef | grep market.py | grep -v "grep" | awk '{print $2}'`
# kill `ps -ef | grep calculate.py | grep -v "grep" | awk '{print $2}'`
# kill `ps -ef | grep account.py | grep -v "grep" | awk '{print $2}'`
# kill `ps -ef | grep signals.py | grep -v "grep" | awk '{print $2}'`
# kill `ps -ef | grep quotation.py | grep -v "grep" | awk '{print $2}'`
# kill `ps -ef | grep risk.py | grep -v "grep" | awk '{print $2}'`
# kill `ps -ef | grep persistence.py | grep -v "grep" | awk '{print $2}'`


# 查看项目运行的日志
t ensure_run.log
# tail -f -n 100 ~/log/ensure_run.log
# tail -f -n 100 ~/log/market.log #
# tail -f -n 200 ~/log/calculate.log # 价差率
# tail -f -n 300 ~/log/account.log # 账户模块
# tail -f -n 300 ~/log/signal.log
# tail -f -n 300 ~/log/quotation.log
# tail -f -n 300 ~/log/risk.log
# tail -f -n 200 ~/log/persistence.log


# 8. 卸载kw_arb项目, 重装
rm -rf ~/kw_arb
git clone -b kw-dev https://github.com/Adolf-L/kw_arb.git
rm -rf ~/lcquant
git clone -b kw-dev https://github.com/Adolf-L/lcquant.git
pip uninstall kwtools
pip install kwtools==0.1.4


# 9. 导出远程端的excel表格
scp -r mirror@45.63.120.150:~/outputs/2021-12-23_16_友幸_财务报表.xlsx ~/Desktop
scp -r mirror@45.63.120.150:~/outputs/2021-12-28_17_友幸_财务报表.xlsx ~/Desktop/outputs
scp -r mirror@45.63.120.150:~/outputs/2022-01-03_09_友幸_财务报表.xlsx ~/Desktop/outputs
