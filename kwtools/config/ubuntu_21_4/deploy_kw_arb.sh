# << 服务器的自动化部署流程 >>
# ===========================================================================================================
# ===========================================================================================================

# 1. 下载'初始化ubunut'的shell脚本, 并执行
wget -O init_ubuntu.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_21_4/init_ubuntu.sh"
vim init_ubuntu.sh # 修改配置内容
chmod +x init_ubuntu.sh
source init_ubuntu.sh


# 2. 切换用户
su kerwin
cd


# 3. 下载'初始化user'的shell脚本, 并执行
wget -O init_user.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_21_4/init_user.sh"
vim init_user.sh # 修改配置内容 (必填: PAT)
chmod +x init_user.sh
source init_user.sh


# 4. 上传二封的vnpy
remote_ip="18.183.104.223" # 需要更新ip
remote_user="mirror"
# 本地端操作 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
cd /usr/local/lib/python3.9/site-packages/vnpy-2.1.9-py3.9.egg
tar zcvf vnpy.tar.gz vnpy # 压缩
scp -r ./vnpy.tar.gz ${remote_user}@${remote_ip}:~/site-packages
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
cd ~/site-packages
tar zxvf vnpy.tar.gz # 解压
pip install peewee --user pkg # vnpy的依赖库
pip install websocket-client --user pkg # vnpy的依赖库


# 5. 上传 kw_arb项目的配置文件
mkdir ~/kw_arb/kw_arb/secret
# 本地端操作 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# 1. config.py
scp -r ~/box/kw_arb/kw_arb/v2_5/config.py ${remote_user}@${remote_ip}:~/kw_arb/kw_arb/v2_5/config.py
# 2. secret.py
scp -r ~/box/kw_arb/kw_arb/secret/secret.py ${remote_user}@${remote_ip}:~/kw_arb/kw_arb/secret/secret.py
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# 6. 添加数据库索引
# i. 进入mongo
sudo docker exec -it lc_mongodb mongo -ulc -plc123456
# ii. 切换数据库
use lc_market_data
# iii. 创建索引
db.funding_rate.createIndex({"lc_symbol":1, "local_timestamp_ms":1}, {"unique":true});
db.open_vspread_rate.createIndex({"spread_symbol":1, "local_timestamp_ms":1}, {"unique":true});
db.close_vspread_rate.createIndex({"spread_symbol":1, "local_timestamp_ms":1}, {"unique":true});
# iv. 展示索引
db.funding_rate.getIndexes();
db.open_vspread_rate.getIndexes();
db.close_vspread_rate.getIndexes();


# 7. 执行kw_arb项目
cd ~
# 导入工具库
wget -O kwtools.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_21_4/kwtools.sh"
chmod +x ~/kwtools.sh
source ~/kwtools.sh
# 启动项目的入口脚本
wget -O ensure_run.sh "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_21_4/ensure_run.sh"
chmod +x ~/ensure_run.sh
ensure_file ~/log folder
nohup ~/ensure_run.sh > ~/log/ensure_run.log & # 如果用nohup, 相当于就是用bash执行shell脚本了(不需要再加source了)


# 查看项目运行的日志
tail -f -n 100 ~/log/ensure_run.log
tail -f -n 100 ~/log/market.log # -f 循环读取
tail -f -n 32 ~/log/calculate.log # -f 循环读取
tail -f -n 100 ~/log/monitor.log
tail -f -n 100 ~/log/output.log


# 查看程序是否正在执行
ps aux | grep ensure_run.sh
ps aux | grep market.py
ps aux | grep calculate.py
ps aux | grep monitor.py
ps aux | grep output_fi_prdl.py


# 8. 卸载kw_arb项目, 重装
rm -rf ~/kw_arb
git clone -b kw-dev https://github.com/Adolf-L/kw_arb.git
rm -rf ~/lcquant
git clone -b kw-dev https://github.com/Adolf-L/lcquant.git
pip uninstall kwtools
pip install kwtools==0.0.8
