#
# 安裝 docker and docker-compose
#
#!/bin/bash

docker_compose_version="1.21.2"

lsb_dist=""
# Every system that we officially support has /etc/os-release
if [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID")"
fi

# install docker
echo "**** 安裝 Docker ****"
sleep 3
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

printf "\n\n"
printf "**** 執行 usermod -aG docker $(whoami) ****\n\n"
sudo usermod -aG docker $(whoami)
sleep 3

# install docker-compose
echo "**** 安裝 docker-compose ${docker_compose_version} ****"
sleep 3
curl -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m` -o docker-compose
sudo mv docker-compose /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

if [ "$lsb_dist" == "centos" ]; then
    echo "**** CentOS 啟用 docker daemon ****"
    sleep 3
    sudo systemctl enable docker
    sleep 3
    sudo systemctl start docker
fi

echo "**** Docker 與 docker-compose 安裝完成 ****"
printf "\n"
echo "**** 請重新登入以使權限生效 ****"
echo "**** 重新登入後可執行以下指令查看版本： ****"
echo "    docker version"
echo "    docker-compose version"
printf "\n"