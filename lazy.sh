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
echo ""
echo "請以可 sudo 之帳號進行"
echo "過程中隨時可以按下 Ctrl + c 中斷"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then
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
    echo "    ${PWD}/${TARGET_DIR}/install.sh"
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
