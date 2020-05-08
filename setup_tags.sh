#!/bin/bash

# 是否顯示訊息以除錯
SHOW_DEBUG=false

# 參考：http://linux-wiki.cn/wiki/zh-tw/%E7%94%A8shell%E5%AE%9E%E7%8E%B0bat%E7%9A%84pause
# 修改： if [...] => if [[...]]
function pause(){
        read -n 1 -p "$*" INP
        if [[ $INP != '' ]] ; then
                echo -ne '\b \n'
        fi
}

printf "\n<<<< 設定 image tag >>>>\n\n"

# 執行中服務數量
SERVICE_COUNT=0
# 服務是否已停止
SERVICE_STOPPED=false
SERVICE_COUNT=$(docker-compose ps | grep Up | wc -l)
if [[ $SERVICE_COUNT -gt 0 ]]; then
    printf "\n執行中服務/容器：\n\n"
    docker-compose ps | grep Up

    printf "\n若已有服務/容器執行中，建議先 停止 容器：\n\n"
    read -p "是否 停止 容器：（是 請輸入大寫 Y，其他視為 否）" ans
    if [[ "$ans" == "Y" ]]; then
        ./down.sh
    fi
fi

SERVICE_COUNT=$(docker-compose ps | grep Up | wc -l)
if [[ $SERVICE_COUNT -eq 0 ]]; then
    # 服務已完全停止或未執行
    SERVICE_STOPPED=true
fi

# for debug
if [[ $SHOW_DEBUG == true ]]; then
    printf "\n\n==== for debug ===="
    printf "\n執行中服務數量： $SERVICE_COUNT"
    printf "\n服務已全部停止： $SERVICE_STOPPED"
    printf "\n\n"
    pause "按任意鍵繼續...."
fi



printf "\n\n**** 以下各項目直接按 Enter 表示不做更改 ****\n\n"

# 設定 PHP_VERSION
printf "設定 PHP 版本 PHP_VERSION\n"
CURRENT_PHP_VERSION=$(cat .env |grep ^PHP_VERSION=)
printf "目前設定 $CURRENT_PHP_VERSION\n"
printf "可用之值：7.0｜7.2｜7.3｜7.4\n"
ans=""
read -p "新設定值： " ans
if [[ "$ans" != "" ]]; then
    ans=PHP_VERSION\=$ans
    sed -i "s/$CURRENT_PHP_VERSION/$ans/g" .env
fi

# 設定 PHP_TAG
printf "\n設定 PHP_TAG"
CURRENT_PHP_TAG=$(cat .env |grep ^PHP_TAG=)
printf "\n目前設定 $CURRENT_PHP_TAG\n"
ans=""
printf "可用之 tag 可至 https://hub.docker.com/r/t301000/xoops.easy.dock.php-fpm/tags 查詢\n"
read -p "新設定值： " ans
if [[ "$ans" != "" ]]; then
    ans=PHP_TAG\=$ans
    sed -i "s/$CURRENT_PHP_TAG/$ans/g" .env
fi

# 設定 CADDY_TAG
printf "\n設定 CADDY_TAG"
CURRENT_CADDY_TAG=$(cat .env |grep ^CADDY_TAG=)
printf "\n目前設定 $CURRENT_CADDY_TAG\n"
ans=""
printf "可用之 tag 可至 https://hub.docker.com/r/t301000/xoops.easy.dock.caddy/tags 查詢\n"
read -p "新設定值： " ans
if [[ "$ans" != "" ]]; then
    ans=CADDY_TAG\=$ans
    sed -i "s/$CURRENT_CADDY_TAG/$ans/g" .env
fi

# 設定 MYSQL_TAG
printf "\n設定 MYSQL_TAG"
CURRENT_MYSQL_TAG=$(cat .env |grep ^MYSQL_TAG=)
printf "\n目前設定 $CURRENT_MYSQL_TAG\n"
ans=""
printf "可用之 tag 可至 https://hub.docker.com/r/t301000/xoops.easy.dock.mysql/tags 查詢\n"
read -p "新設定值： " ans
if [[ "$ans" != "" ]]; then
    ans=MYSQL_TAG\=$ans
    sed -i "s/$CURRENT_MYSQL_TAG/$ans/g" .env
fi

printf "\n*****************************"
printf "\n以下是新的 image tag 設定："
printf "\n*****************************\n\n"
cat .env |grep ^PHP_VERSION=
cat .env |grep ^PHP_TAG=
cat .env |grep ^CADDY_TAG=
cat .env |grep ^MYSQL_TAG=
printf "\n\n"
ans=""
# printf "須啟動/重新啟動容器才會生效\n"
read -p "是否 立即啟動 服務/容器：（是 請輸入大寫 Y，其他視為 否）" ans
if [[ "$ans" == "Y" ]]; then
    if [[ $SERVICE_STOPPED == false ]]; then
        # 若服務未停止則先停止服務
        ./down.sh
    fi
    ./up.sh
    exit 0
fi
printf "\n你選擇不立即啟動服務/容器"
printf "\n\n*****************************"
printf "\n若要啟動服務/容器以使變更生效，請依序執行以下指令："
if [[ $SERVICE_STOPPED == false ]]; then
    printf "\n    ./down.sh"
fi
printf "\n    ./up.sh"
printf "\n*****************************\n\n"

exit 0
