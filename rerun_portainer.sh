#!/bin/bash
#
# 刪除 portainer 容器
# 下載新版 portainer image
# 重啟 portainer 容器
#

# 顯示說明
clear
echo "//////////////////////////////////////////////////"
echo "此步驟將移除現有的 portainer 容器"
echo "再啟動一個新的 portainer 容器"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then
    docker container rm -f portainer && docker image pull portainer/portainer && ./run_portainer.sh
fi
