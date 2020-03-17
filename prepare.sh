#!/bin/bash

# 顯示說明
clear
echo "//////////////////////////////////////////////////"
echo "此步驟將下載 XOOPS輕鬆架 安裝檔"
echo "並進行安裝前置作業"
echo "請以可 sudo 之帳號進行"
echo "若已執行過則請跳過此步驟"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then
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
    # 2020.03.17
    # 修正：新安裝界面無法輸入資料庫主機
    # 檔案：xoops_data/data/secure.php
    # 32 行 將常數值改為 mysql
    # 原來：define('XOOPS_DB_HOST', 'localhost');
    sed -i 's/localhost/mysql/g' public/xoops_data/data/secure.php
    
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

    printf "***** xoops 安裝前置作業完成 *****\n\n"
fi
