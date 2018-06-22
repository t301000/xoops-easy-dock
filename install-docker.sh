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
echo "**** 安裝 docker ****"
sleep 3
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

echo "執行 usermod -aG docker $(whoami)"
sudo usermod -aG docker $(whoami)

# install docker-compose
echo "**** 安裝 docker-compose ****"
sleep 3
curl -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m` -o docker-compose
sudo mv docker-compose /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

if [ "$lsb_dist" == "centos" ]; then
    echo "**** CentOS 啟用 docker daemon ****"
    sudo systemctl enable docker
    sudo systemctl start docker
fi

echo "**** 安裝完成 ****"
echo "**** 請先重新登入 ****"
echo "**** 重新登入後可執行以下指令查看版本： ****"
echo "docker version"
echo "docker-compose version"