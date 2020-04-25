#
# 安裝 docker and docker-compose
#
# Ubuntu 20.04 起改由 default apt source 安裝 docker
#
#!/bin/bash

# 顯示說明
clear
echo "//////////////////////////////////////////////////"
echo "此步驟將安裝 Docker 與 docker-compose"
echo "請以可 sudo 之帳號進行"
echo "若已安裝過則請跳過此步驟"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then

    # install docker
    echo "**** 安裝 Docker ****"
    sleep 3
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl enable --now docker

    printf "\n\n"
    printf "**** 執行 usermod -aG docker $(whoami) ****\n\n"
    sudo usermod -aG docker $(whoami)
    sleep 3

    # install docker-compose
    echo "**** 安裝 docker-compose ****"
    sleep 3
    compose_version=$(curl https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
    echo ">>>> docker-compose 版本： ${compose_version}"
    output='/usr/local/bin/docker-compose'
    sudo curl -L https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m) -o $output
    sudo chmod +x $output
    echo $(docker-compose --version)
    printf "\n\n"

    echo "**** Docker 與 docker-compose 安裝完成 ****"
    printf "\n"

fi
