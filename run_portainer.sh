#
# 在本機建立一個 portainer container
#
#!/bin/bash

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

# 詢問是否正確，預設 y
read -p "以上設定正確？(預設： Y)[Y/n]" ok
if [ "${ok}" == "y" ] || [ "${ok}" == "Y" ] || [ "${ok}" == "" ];then
echo "**** 正在啟動 portainer container ****"

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

echo "**** portainer container 已啟動 ****"
echo "**** 可由以下網址進入 ****"
echo "    http://ip:9000"
printf "\n"
