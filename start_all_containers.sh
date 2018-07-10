#
# 在本機建立一個 portainer container
#
#!/bin/bash

# 顯示說明
clear
echo "////////////////////////////////////////"
echo "此步驟將啟動 Caddy、PHP-FPM 與 MySQL 容器"
echo "第一次啟動會下載映像檔，請耐心等待"
echo "////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then
    sudo /usr/local/bin/docker-compose up -d
fi
