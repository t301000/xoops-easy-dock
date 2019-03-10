#
# CentOS 防火牆開放 http 與 https
#
#!/bin/bash

# 顯示說明
clear
echo "//////////////////////////////////////////////////"
echo "此步驟將使 CentOS 防火牆開放 http 與 https"
echo "請以可 sudo 之帳號進行"
echo "若非 CentOS 則請跳過此步驟"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then
    echo ">>>> 設定防火牆...."
    sudo firewall-cmd --add-service=http --add-service=https --permanent
    echo ">>>> 重新載入防火牆...."
    sudo firewall-cmd --reload
    echo ">>>> 目前防火牆設定："
    sudo firewall-cmd --list-all
fi
