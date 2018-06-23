#!/bin/bash

lsb_dist=""
# Every system that we officially support has /etc/os-release
if [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID")"
fi

if [ ! -f /usr/bin/unzip ] ; then
    printf "***** 安裝 unzip *****\n\n"
    if [ "$lsb_dist" == "centos" ]; then
        sudo yum install -y unzip vim
    else
        sudo apt install -y unzip vim
    fi
fi

if [ ! -f my_xoops.zip ] ; then
    printf "***** 開始下載最新版安裝檔 *****\n\n"
    curl -L http://120.115.2.90/uploads/my_xoops.zip -o my_xoops.zip
fi

printf "***** 開始解壓縮 *****\n\n"
if [ ! -d site ] ; then
    mkdir site
fi
sudo chmod 777 site
unzip my_xoops.zip -d site/public > /dev/null

printf "***** 搬移 xoops_data、xoops_lib *****\n\n"
cd site
mv public/xoops_* .

printf "***** 變更資料夾權限 *****\n\n"
chmod 777 -Rf xoops_data public/uploads
cd ..

if [ ! -d db_data ] ; then
    mkdir -p db_data/mysql
    chmod 777 -Rf db_data
fi

if [ ! -d logs ] ; then
    mkdir -p logs/caddy
    chmod 777 -Rf logs
fi

printf "***** 完成 *****\n\n"

# echo "設定 .env 執行："
# printf "    ./setup-env.sh\n\n"
# echo "設定 caddy server 執行："
# printf "    ./setup-caddy.sh\n\n"

# printf "執行以下指令啟動 container：\n"
# printf "      docker-compose up -d\n\n"
