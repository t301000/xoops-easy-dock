#!/bin/bash
#
# 懶人安裝檔
#

# 顯示說明
clear
echo "//////////////////////////////////////////////////"
echo "此為 xoops-easy-dock 之懶人安裝批次檔"
echo ""
echo "請依序執行安裝選單之各步驟並詳閱說明"
echo "過程中各選項若有預設值，直接按下 Enter 即可採用預設值"
echo ""
echo "請以可 sudo 之帳號進行"
echo "過程中隨時可以按下 Ctrl + c 中斷"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then

    # 偵測作業系統，安裝必要套件，CentOS 開啟防火牆 80 443 port
    myos=""
    # Every system that we officially support has /etc/os-release
    if [ -r /etc/os-release ]; then
        myos="$(. /etc/os-release && echo "$ID")"
    fi
    if [ "$myos" == "centos" ]; then
        echo "**** 作業系統為 CentOS ，安裝必要套件 ****"
        sudo yum install -y epel-release
        sudo yum install -y unzip curl deltarpm jq

        echo "**** 作業系統為 CentOS ，防火牆開放 http 與 https ****"
        echo ">>>> 設定防火牆...."
        sudo firewall-cmd --add-service=http --add-service=https --permanent
        echo ">>>> 重新載入防火牆...."
        sudo firewall-cmd --reload
        echo ">>>> 目前防火牆設定："
        sudo firewall-cmd --list-all
    fi
    if [ "$myos" == "ubuntu" ]; then
        echo "**** 作業系統為 Ubuntu ，安裝必要套件 ****"
        sudo apt update && sudo apt install -y unzip curl jq
    fi
    # 偵測作業系統，安裝必要套件完成

    TARGET_DIR="xoops"

    #### 開始 ####

    value=""
    read -p "安裝目錄名稱：(預設： xoops)  " value
    if [[ "$value" != "" ]]; then
        TARGET_DIR=$value
    fi
    printf ">>>> 安裝路徑： ${PWD}/${TARGET_DIR}/\n\n"

    echo "////////////////////////////////////////"
    echo "以後若要叫出安裝選單，請執行"
    echo "    cd ${PWD}/${TARGET_DIR}"
    echo "    ./install.sh"
    echo "////////////////////////////////////////"
    sleep 5

    echo "***** 下載 xoops-easy-dock *****"
    printf "\n"
    curl -L https://github.com/t301000/xoops-easy-dock/archive/master.zip -o master.zip
    unzip master.zip
    mv xoops-easy-dock-master $TARGET_DIR
    cd $TARGET_DIR
    ./install.sh
fi
