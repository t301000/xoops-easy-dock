#!/bin/bash
#
# 安裝 xoops-easy-dock
#

# 參考資料：
# menu example => https://askubuntu.com/a/1716
# PS3 => http://benjr.tw/96409
show_menu() {
    printf "\n\n"
    echo "*********************************"
    echo "   xoops-easy-dock 安裝"
    echo ""
    echo "   若要再次召喚此選單，請執行："
    echo "      cd ${PWD}"
    echo "      ./install.sh"
    echo "*********************************"
    printf "\n"

    PS3='請輸入要執行的項目編號：[1-9]  '
    options=("安裝Docker" "準備作業" "設定.env" "設定caddy" "啟動caddy與MySQL" "啟動portainer" "離開" "更新/重啟portainer" "CentOS防火牆開放http與https")
    select opt in "${options[@]}"
    do
        case $opt in
            "安裝Docker")
                echo "**** 安裝 Docker 與 docker-compose ****"

                # 是否使用 docker 官方 apt 來源
                USE_DOCKER_APT=true
                # 判斷是否為 ubuntu 20.04 以後（含）
                if [ -r /etc/os-release ]; then
                    OS_DIST="$(. /etc/os-release && echo "$ID")"

                    if [[ "$OS_DIST" == "ubuntu" ]]; then
                        MAIN_VERSION=$(. /etc/os-release && echo "$VERSION_ID" | cut -d'.' -f 1)

                        if [[ $MAIN_VERSION -ge 20 ]]; then
                            # ubuntu 20.04 以後（含），直接由預設 apt 來源安裝
                            USE_DOCKER_APT=false
                            ./install-docker-from-ubuntu-default-apt.sh
                        fi
                    fi
                fi

                # 使用 docker 官方 apt 來源
                if [[ $USE_DOCKER_APT == true ]]; then
                    ./install-docker.sh
                fi

                echo ""
                echo "////////////////////"
                echo "    步驟 1 已完成"
                echo "////////////////////"
                echo ""
                show_menu
                ;;
            "準備作業")
                echo "**** 進行準備作業 ****"
                ./prepare.sh
                echo ""
                echo "////////////////////"
                echo "    步驟 2 已完成"
                echo "////////////////////"
                echo ""
                show_menu
                ;;
            "設定.env")
                echo "**** 進行 .env 設定 ****"
                ./setup-env.sh
                echo ""
                echo "////////////////////"
                echo "    步驟 3 已完成"
                echo "////////////////////"
                echo ""
                show_menu
                ;;
            "設定caddy")
                echo "**** 進行 caddy server 設定 ****"
                ./setup-caddy.sh
                echo ""
                echo "////////////////////"
                echo "    步驟 4 已完成"
                echo "////////////////////"
                echo ""
                show_menu
                ;;
            "啟動caddy與MySQL")
                echo "**** 啟動 caddy、 php-fpm、 MySQL service ****"
                ./start_all_containers.sh
                echo ""
                echo "////////////////////"
                echo "    步驟 5 已完成"
                echo "////////////////////"
                echo ""
                show_menu
                ;;
            "啟動portainer")
                echo "**** 啟動 portainer container ****"
                ./run_portainer.sh
                echo ""
                echo "////////////////////"
                echo "    步驟 6 已完成"
                echo "////////////////////"
                echo ""
                show_menu
                ;;
            "離開")
                printf "\n\n"
                exit
                ;;
            "更新/重啟portainer")
                echo "**** 更新/重啟 portainer container ****"
                ./rerun_portainer.sh
                echo ""
                echo "////////////////////"
                echo "    步驟 8 已完成"
                echo "////////////////////"
                echo ""
                show_menu
                ;;
            "CentOS防火牆開放http與https")
                echo "**** CentOS 防火牆開放 http 與 https ****"
                ./centos_firewalld_http_https.sh
                echo ""
                echo "////////////////////"
                echo "    步驟 9 已完成"
                echo "////////////////////"
                echo ""
                show_menu
                ;;
            *)
                ;;
        esac
    done
}
clear
show_menu
