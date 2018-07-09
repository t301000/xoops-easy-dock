#!/bin/bash
#
# 懶人安裝檔
#

TARGET_DIR="xoops"

#### 開始 ####

echo "***** xoops-easy-dock 懶人安裝 *****"
printf "按下 Ctrl + c 可中斷\n\n"


value=""
read -p "安裝目錄名稱：(預設： xoops)  " value
if [[ "$value" != "" ]]; then
    TARGET_DIR=$value
    printf ">>>> 安裝路徑： ${PWD}/${TARGET_DIR}/\n\n"
fi

echo "***** 下載 xoops-easy-dock *****"
printf "\n"
curl -L https://github.com/t301000/xoops-easy-dock/archive/master.zip -o master.zip
unzip master.zip
mv xoops-easy-dock-master $TARGET_DIR
cd $TARGET_DIR
./install.sh
