#!/bin/bash
####################
#  還原
####################


#######################
#    變數區
#######################

# xoops 安裝目錄
INSTALL_PATH=_INSTALL_PATH
# 備份檔目錄，安裝目錄同一層的 xoops_backup 目錄
BACKUP_DIR="$(dirname ${INSTALL_PATH})/xoops_backup"

# docker-compose 執行檔路徑
DOCKER_COMPOSE="/usr/local/bin/docker-compose"
# 使用的 docker-compose.yml 檔路徑
DOCKER_COMPOSE_YML="${INSTALL_PATH}/docker-compose-prod.yml"
# .env 路徑
ENVFILE="${INSTALL_PATH}/.env"
# 啟動容器之指令，含參數
UP="${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_YML} --env-file ${ENVFILE} up -d"
# 停止容器之指令，含參數
DOWN="${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_YML} --env-file ${ENVFILE} down"
# docker-compose ps 之指令，含參數
DOCKER_COMPOSE_PS="${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_YML} --env-file ${ENVFILE} ps"


#######################
#    函數區
#######################

# 參考：http://linux-wiki.cn/wiki/zh-tw/%E7%94%A8shell%E5%AE%9E%E7%8E%B0bat%E7%9A%84pause
# 修改： if [...] => if [[...]]
function pause(){
        read -n 1 -p "$*" INP
        if [[ $INP != '' ]] ; then
                echo -ne '\b \n'
        fi
}


#######################
#    執行區
#######################

# 若備份檔目錄不存在則離開
if [[ ! -d $BACKUP_DIR ]];then
  exit 0
fi


printf "\n"
echo "#########################"
echo "#"
echo "#      還原 xoops"
echo "#"
echo "#########################"


# 輸出檔案列表
printf "\n\n"
printf "備份時間列表："
printf "\n\n"
BACKUP_FILE_LIST="/tmp/backup_file_list"
ls ${BACKUP_DIR}/backup_*.tar.gz > $BACKUP_FILE_LIST && sed -i "s:${BACKUP_DIR}/backup_::g" $BACKUP_FILE_LIST && sed -i "s/.tar.gz//g" $BACKUP_FILE_LIST
file_count=$(wc -l < $BACKUP_FILE_LIST)
if [[ $file_count -gt 0 ]]; then
    cat $BACKUP_FILE_LIST
    rm -f $BACKUP_FILE_LIST
else
    rm -f $BACKUP_FILE_LIST
    echo "沒有備份...."
    printf "\n\n"
    exit 0
fi


printf "\n\n"
read -p "輸入欲還原的時間點： " date_time
# 未輸入或檔案不存在則離開
BACKUP_FILENAME="backup_${date_time}.tar.gz"
if [[ "$date_time" == "" ]] || [[ ! -f ${BACKUP_DIR}/${BACKUP_FILENAME} ]]; then
    printf "\n\n"
    printf "檔案 ${BACKUP_FILENAME} 不存在！！"
    printf "\n\n"
    exit 0
fi


printf "\n\n"
printf "即將由 ${BACKUP_FILENAME} 進行還原"
printf "\n\n"
pause ">>> 按任意鍵開始還原 或 Ctrl + C 中斷執行...."
printf "\n\n"

# 若有容器執行則先停止容器 -> 還原 -> 啟動容器
SERVICE_COUNT=0
if [[ -d $INSTALL_PATH ]];then
    SERVICE_COUNT=$($DOCKER_COMPOSE_PS | grep Up | wc -l)
fi
if [[ $SERVICE_COUNT -gt 0 ]]; then
    $DOWN
fi
sudo tar -zxvp -f ${BACKUP_DIR}/${BACKUP_FILENAME} -C / && $UP

printf "\n\n"
printf "==== 還原完成並已啟動容器 ===="
printf "\n\n"
exit 0
