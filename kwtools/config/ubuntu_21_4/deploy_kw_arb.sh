# << 服务器的自动化部署流程 >>
# ===========================================================================================================
# ===========================================================================================================

# 1. 下载'初始化ubunut'的shell脚本, 并执行
wget "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_21_4/init_ubuntu.sh"
# vim init_ubuntu.sh # 修改配置内容
chmod +x init_ubuntu.sh
source init_ubuntu.sh


# 2. 切换用户
su kerwin
cd


# 3. 下载'初始化user'的shell脚本, 并执行
wget "https://raw.githubusercontent.com/kerwin6182828/kwtools/main/kwtools/config/ubuntu_21_4/init_user.sh"
# vim init_ubuntu.sh # 修改配置内容 (必填: PAT)
chmod +x init_user.sh
source init_user.sh


# 4. 上传二封的vnpy
ip_address="202.182.110.161" # 需要更新ip
# 本地端操作 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
cd /usr/local/lib/python3.9/site-packages/vnpy-2.1.9-py3.9.egg
tar zcvf vnpy.tar.gz vnpy # 压缩
scp -r ./vnpy.tar.gz kerwin@${ip_address}:~/site-packages
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
cd ~/site-packages
tar zxvf vnpy.tar.gz # 解压
pip install peewee --user pkg # vnpy的依赖库
pip install websocket-client --user pkg # vnpy的依赖库


# 5. 上传 kw_arb项目的配置文件
mkdir ~/kw_arb/kw_arb/secret
# 本地端操作 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# 1. config.py
scp -r ~/box/kw_arb/kw_arb/v2_5/config.py kerwin@${ip_address}:~/kw_arb/kw_arb/v2_5/config.py
# 2. secret.py
scp -r ~/box/kw_arb/kw_arb/secret/secret.py kerwin@${ip_address}:~/kw_arb/kw_arb/secret/secret.py
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# 6. 添加数据库索引
sudo docker exec -it lc_mongodb mongo -ulc -plc123456
use lc_market_data
db.funding_rate.ensureIndex({"lc_symbol":1, "local_timestamp_ms":1}, {"unique":true})
db.open_vspread_rate.ensureIndex({"spread_symbol":1, "local_timestamp_ms":1}, {"unique":true})
