#!/bin/bash
printf "\n<<<< 設定 image tag >>>>\n\n"
printf "\n將先停止容器以策安全：\n\n"
read -p "是否 停止 容器：（是 請輸入大寫 Y，其他視為 否）" ans
if [[ "$ans" == "Y" ]]; then
    #./down.sh && ./up.sh
    ./down.sh
else
	printf "\n請先停止容器再重新執行 image tag 設定。"
	printf "\n    ./down.sh"
	printf "\n    ./setup_tags.sh"
	exit 0
fi


printf "**** 以下各項目直接按 Enter 表示不做更改 ****\n\n"

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
read -p "是否 立即啟動 容器：（是 請輸入大寫 Y，其他視為 否）" ans
if [[ "$ans" == "Y" ]]; then
    #./down.sh && ./up.sh
    ./up.sh
    exit 0
fi
printf "\n你選擇不立即啟動容器"
printf "\n\n*****************************"
printf "\n若要啟動容器，請執行以下指令："
printf "\n    ./up.sh"
printf "\n*****************************\n\n"

exit 0
