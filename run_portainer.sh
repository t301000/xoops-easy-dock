#
# 在本機建立一個 portainer container
#
#!/bin/bash

# 顯示說明
clear
echo "//////////////////////////////////////////////////"
echo "此步驟將啟動一個管理用之容器，其名稱為 portainer"
echo "可由 web 界面管理容器"
echo ""
echo "此步驟可以不做"
echo ""
echo "請以可 sudo 之帳號進行"
echo ""
echo "以下各步驟若不清楚可採預設值"
echo "若已安裝過則請跳過此步驟"
echo ""
echo "若為 CentOS 則須設定防火牆開放連線 port（預設 9000）"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then
    echo "**** 設定 portainer container ****"
    echo "**** Ctrl + c 可中斷           ****"

    # 是否為測試模式，預設為 否
    #read -p "測試模式：(預設： N)[y/N]" rm_mode
    #rm_arg="-d"
    #rm_message="Test mode: No"
    #if [ "${rm_mode}" == "y" ] || [ "${rm_mode}" == "Y" ];then
    #  rm_arg="--rm"
    #  rm_message="測試模式"
    #fi
    #echo "${rm_message}"


    # 輸入 image tag，預設為 latest
    read -p "image 標籤：(Default: latest) " tag
    if [ "${tag}" == "" ];then
      tag="latest"
    fi
    echo "image 標籤：${tag}"
    echo ""

    # 輸入 container name，預設為 自動
    #read -p "Container 名稱：(預設： auto) " container_name
    #name_message="自動產生"
    #name_arg=""
    #if [ "${container_name}" != "" ];then
    #  name_arg="--name ${container_name}"
    #  name_message="${container_name}"
    #fi
    #echo "Container 名稱：${name_message}"

    # 輸入 host port，預設為 9000
    read -p "連線 port 號：(預設： 9000) " host_port
    if [ "${host_port}" == "" ];then
      host_port=9000
    fi
    echo "port： ${host_port}"
    echo ""

    # 輸入 Data volume path or name，預設為 自動
    #read -p "Data volume 路徑或名稱：(預設： Auto) " data_path
    #data_path_message="自動產生"
    #data_path_arg=""
    #if [ "${data_path}" != "" ];then
    #  data_path_arg="-v ${data_path}:/data"
    #  data_path_message="${data_path}"
    #fi
    #echo "Data volume 路徑或名稱： ${data_path_message}"

    # 非測試模式，則啟用 restart policy
    #if [ "${rm_arg}" == "-d" ];then
    #	# 輸入 重新啟動 策略，預設為 unless-stopped
    #	read -p "重新啟動策略：(預設： unless-stopped)[unless-stopped | always]" policy
    #	default_policy="unless-stopped"
    #	if [ "${policy}" == "unless-stopped" ] || [ "${policy}" == "always" ];then
    #	  default_policy="${policy}"
    #	fi
    #	policy_arg="--restart=${default_policy}"
    #	echo "重新啟動策略： ${default_policy}"
    #fi
    #輸入 重新啟動 策略，預設為 unless-stopped
    read -p "重新啟動策略：(預設： unless-stopped)[unless-stopped | always]" policy
    default_policy="unless-stopped"
    if [ "${policy}" == "unless-stopped" ] || [ "${policy}" == "always" ];then
      default_policy="${policy}"
    fi
    policy_arg="--restart=${default_policy}"
    echo "重新啟動策略： ${default_policy}"
    echo ""

    # 詢問是否正確，預設 y
    read -p "以上設定正確？(預設： Y)[Y/n]" ok
    if [ "${ok}" == "y" ] || [ "${ok}" == "Y" ] || [ "${ok}" == "" ];then
    echo "**** 正在啟動 portainer container ****"
    echo ""

    #docker container run ${name_arg} \
    #${rm_arg} \
    #-p ${host_port}:9000 \
    #${policy_arg} \
    #-v /var/run/docker.sock:/var/run/docker.sock \
    #${data_path_arg} \
    #portainer/portainer:${tag}
    sudo docker container run --name portainer \
    -d \
    -p ${host_port}:9000 \
    ${policy_arg} \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer:${tag}
    fi

    # CentOS 防火牆設定
    read -p "是否為 CentOS ？(預設： N)[y/N]" ans
    if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
        echo ">>>> 設定防火牆開放 ${host_port} port"
        sudo firewall-cmd --add-port=${host_port}/tcp --permanent
        sudo firewall-cmd --reload
        echo ">>>> 目前防火牆設定："
        sudo firewall-cmd --list-all
    fi

    echo ""
    echo "**** portainer container 已啟動 ****"
    echo ""
    echo "**** 可由以下網址進入 ****"
    echo "    http://ip:${host_port}"
    echo ""
    echo "    第一次進入請設定帳號與密碼"
    echo "    第二個畫面請選擇 local，再按下 connect 按鈕"
    printf "\n"
fi
