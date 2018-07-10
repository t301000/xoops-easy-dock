#!/bin/bash
#
# 設定 .env
#

# 顯示說明
clear
echo "//////////////////////////////////////////////////"
echo "此步驟將設定並產生 xoops-easy-dock 之環境設定檔"
echo "檔案位於："
echo "    ${PWD}/.env"
echo "若已執行過則請跳過此步驟"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then
    # 樣板檔
    TPL_FILE="env-example-prod"

    MYSQL_DATABASE="default"
    MYSQL_USER="default"
    MYSQL_PASSWORD="secret"
    MYSQL_PORT="3306"
    MYSQL_ROOT_PASSWORD="root"

    #### 開始 ####

    echo "***** 設定 MySQL *****"
    echo "//////////////////////////////////////////////////"
    echo "系統將根據以下各項設定執行："
    echo "    建立資料庫"
    echo "    建立資料庫帳號並設定密碼"
    echo "    設定資料庫 root 密碼"
    echo "//////////////////////////////////////////////////"
    printf "按下 Ctrl + c 可中斷\n\n"


    value=""
    read -p "資料庫名稱：(預設： default)  " value
    if [[ "$value" != "" ]]; then
        MYSQL_DATABASE=$value
    fi

    value=""
    read -p "資料庫帳號：(預設： default)  " value
    if [[ "$value" != "" ]]; then
        MYSQL_USER=$value
    fi

    value=""
    read -p "資料庫密碼：(預設： secret)  " value
    if [[ "$value" != "" ]]; then
        MYSQL_PASSWORD=$value
    fi

    value=""
    read -p "資料庫 root 密碼：(預設： root)  " value
    if [[ "$value" != "" ]]; then
        MYSQL_ROOT_PASSWORD=$value
    fi

    #value=""
    #read -p "資料庫 port：(預設： 3306)  " value
    #if [[ "$value" != "" ]]; then
    #    MYSQL_PORT=$value
    #fi


    if [[ -f .env ]]; then
        DATE=`date '+%Y%m%d%H%M%S'`
        echo "備份 .env => .env.bak-${DATE}"
        mv .env .env.bak-${DATE}
    fi

    printf "\n\n"
    echo "產生 .env..."

    cp $TPL_FILE env-temp

    echo "MYSQL_DATABASE=${MYSQL_DATABASE}" >> env-temp
    echo "MYSQL_USER=${MYSQL_USER}" >> env-temp
    echo "MYSQL_PASSWORD=${MYSQL_PASSWORD}" >> env-temp
    echo "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" >> env-temp
    #echo "MYSQL_PORT=${MYSQL_PORT}" >> env-temp

    mv env-temp .env

    printf ".env 設定完成！！\n\n"
fi
