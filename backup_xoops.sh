#!/bin/bash
####################
#  備份
####################

# xoops 安裝目錄
INSTALL_PATH=/home/shihli/projects/xoops-easy-dock
# docker-compose 執行檔路徑
DOCKER_COMPOSE="/usr/local/bin/docker-compose"
# 備份檔目錄，安裝目錄同一層的 backup 目錄
BACKUP_DIR="${INSTALL_PATH}/../backup"
# 使用的 docker-compose.yml 檔路徑
DOCKER_COMPOSE_YML="${INSTALL_PATH}/docker-compose-prod.yml"
# .env 路徑
ENVFILE="${INSTALL_PATH}/.env"
# 啟動容器之指令，含參數
UP="${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_YML} --env-file ${ENVFILE} up -d"
# 停止容器之指令，含參數
DOWN="${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_YML} --env-file ${ENVFILE} down"

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

exit 0
