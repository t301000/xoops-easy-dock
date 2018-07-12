#!/bin/bash
#
# 執行清理工作
#

confirm() {
    local ans=""
    read -p "確定執行？[yes/N] " ans

    # 不是輸入 yes 則顯示選單
    if [ "${ans}" != "yes" ]; then
        echo "--- 取消執行"
        show_menu
    fi
}

echoOK() {
    echo "+++ 完成"
}

# 參考資料：
# menu example => https://askubuntu.com/a/1716
# PS3 => http://benjr.tw/96409
show_menu() {
    printf "\n\n"
    echo "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
    echo "         執行清理工作"
    # echo -e "         \e[31m！！注意！！\e[0m"
    echo -e "         \e[41m！！注意！！\e[0m"
    echo "     檔案經刪除即無法回復"
    echo "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
    printf "\n"

    PS3='請輸入要清理的項目編號：[1-8] '
    options=("停止並移除容器" "停止並移除portainer" "清除資料庫檔案" "清除caddy日誌檔" "清除網站檔案" "清除xoops安裝檔" "清除.env" "離開")
    select opt in "${options[@]}"
    do
        case $opt in
            "停止並移除容器")
                echo ">>> 停止並移除 caddy、php-fpm、MySQL 容器"
                confirm

                docker-compose -f docker-compose-prod.yml down

                echoOK
                show_menu
                ;;
            "停止並移除portainer")
                echo ">>> 停止並移除portainer"
                confirm

                docker container rm -f -v portainer
                docker volume prune -f

                echoOK
                show_menu
                ;;
            "清除資料庫檔案")
                echo ">>> 清除資料庫檔案"
                confirm

                sudo rm -rf db_data/mysql
                mkdir -p db_data/mysql
                chmod 777 -Rf db_data

                echoOK
                show_menu
                ;;
            "清除caddy日誌檔")
                echo ">>> 清除caddy日誌檔"
                confirm

                sudo rm -rf logs/caddy/*

                echoOK
                show_menu
                ;;
            "清除網站檔案")
                echo ">>> 清除網站檔案"
                confirm

                sudo rm -rf site

                echoOK
                show_menu
                ;;
            "清除xoops安裝檔")
                echo ">>> 清除xoops安裝檔"
                confirm

                rm -f my_xoops.zip

                echoOK
                show_menu
                ;;
            "清除.env")
                echo ">>> 清除.env"
                confirm

                rm -f .env

                echoOK
                show_menu
                ;;
            "離開")
                printf "\n\n"
                exit
                ;;
            *)
                ;;
        esac
    done
}

show_menu


















#ans=""
#read -p "是否停止並移除 portainer 容器？[y/N]" ans
#if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
#  docker rm -f -v portainer
#  docker volume prune -f
#fi
#
#ans=""
#read -p "是否清除資料庫檔案？[y/N]" ans
#if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
#  # sudo rm -rf db_data/mysql/*
#  sudo rm -rf db_data/mysql
#  mkdir -p db_data/mysql
#  chmod 777 -Rf db_data
#  echo "***** 資料庫檔案清除完畢 *****"
#fi
#
#ans=""
#read -p "是否清除 web log 檔案？[y/N]" ans
#if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
#  sudo rm -rf logs/caddy/*
#  echo "***** web log 檔案清除完畢 *****"
#fi
#
#ans=""
#read -p "是否清除 網站 檔案？[y/N]" ans
#if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
#  sudo rm -rf site
#  echo "***** 網站 檔案清除完畢 *****"
#fi
#
#ans=""
#read -p "是否清除 環境設定檔 .env ？[y/N]" ans
#if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
#  sudo rm -f .env
#  echo "***** 環境設定檔 .env 清除完畢 *****"
#fi
#
#printf "\n***** 清除動作已執行完畢 *****\n\n"
