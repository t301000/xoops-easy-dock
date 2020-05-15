#!/bin/bash
####################
#  備份
####################

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

# username
MY_USERNAME=_MY_USERNAME
# 保留幾份
KEEP_COUNT=_KEEP_COUNT


# 若安裝目錄不存在則離開
if [[ ! -d $INSTALL_PATH ]];then
  exit 0
fi


# 若備份檔目錄不存在則建立之
if [[ ! -d $BACKUP_DIR ]];then
  mkdir $BACKUP_DIR
fi
# 備份檔名之時間後綴
BACKUP_DATE=`date '+%Y%m%d%H%M%S'`
# 備份檔名，含路徑
BACKUP_FILE="${BACKUP_DIR}/backup_${BACKUP_DATE}.tar.gz"

# 停止容器 -> 備份 -> 啟動容器
$DOWN && tar -zcvp -f $BACKUP_FILE $INSTALL_PATH && $UP
# 執行 chown
chown ${MY_USERNAME}.${MY_USERNAME} ${BACKUP_FILE}

# 移除檔案之清單
DELETE_FILE_LIST="/tmp/list_to_delete"
# 清理備份檔
ls ${BACKUP_DIR}/backup_*.tar.gz > $DELETE_FILE_LIST
# 總數
total_count=$(cat $DELETE_FILE_LIST | wc -l)
# 超過保留數量則清理
if [[ $total_count -gt $KEEP_COUNT ]]; then
    # 開始行數，由此開始為要保留的檔案
    line_start=$(( $total_count - $KEEP_COUNT +1 ))
    # 要保留的檔案由清單中移除
    sed -i "${line_start},${total_count}d" $DELETE_FILE_LIST
    # 移除清單中之檔案
    rm -f $(<$DELETE_FILE_LIST)
fi
rm -f $DELETE_FILE_LIST

exit 0
