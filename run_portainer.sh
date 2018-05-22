#
# 在本機建立一個 portainer container
#
#!/bin/bash

echo "**** setup a portainer container ****"
echo "**** Ctrl + c to abort           ****"

# 是否為測試模式，預設為 否
read -p "Test mode : (Default: N)[y/N]" rm_mode
rm_arg="-d"
rm_message="Test mode: No"
if [ "${rm_mode}" == "y" ] || [ "${rm_mode}" == "Y" ];then
  rm_arg="--rm"
  rm_message="Test mode: Yes"
fi
echo "${rm_message}"


# 輸入 image tag，預設為 latest
read -p "Image tag : (Default: latest) " tag
if [ "${tag}" == "" ];then
  tag="latest"
fi
echo "${tag}"

# 輸入 container name，預設為 自動
read -p "Container name : (Default: auto) " container_name
name_message="auto generated"
name_arg=""
if [ "${container_name}" != "" ];then
  name_arg="--name ${container_name}"
  name_message="${name_arg}"
fi
echo "${name_message}"

# 輸入 host port，預設為 9000
read -p "Host port : (Default: 9000) " host_port
if [ "${host_port}" == "" ];then
  host_port=9000
fi
echo "${host_port}"

# 輸入 Data volume path or name，預設為 自動
read -p "Data volume path or name : (Default: Auto) " data_path
data_path_message="auto generated"
data_path_arg=""
if [ "${data_path}" != "" ];then
  data_path_arg="-v ${data_path}:/data"
  data_path_message="${data_path_arg}"
fi
echo "${data_path_message}"

# 非測試模式，則啟用 restart policy
if [ "${rm_arg}" == "-d" ];then
	# 輸入 重新啟動 策略，預設為 unless-stopped
	read -p "Restart policy : (Default: unless-stopped)[unless-stopped | always]" policy
	default_policy="unless-stopped"
	if [ "${policy}" == "unless-stopped" ] || [ "${policy}" == "always" ];then
	  default_policy="${policy}"
	fi
	policy_arg="--restart=${default_policy}"
	echo "${policy_arg}"
fi

# 詢問是否正確，預設 y
read -p "All correct ? (Default: Y)[Y/n]" ok
if [ "${ok}" == "y" ] || [ "${ok}" == "Y" ] || [ "${ok}" == "" ];then
echo "**** running a portainer container ****"

docker container run ${name_arg} \
${rm_arg} \
-p ${host_port}:9000 \
${policy_arg} \
-v /var/run/docker.sock:/var/run/docker.sock \
${data_path_arg} \
portainer/portainer:${tag}
fi
