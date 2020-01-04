#!/bin/bash
printf "\n<<<< xoops-easy-dock 更新 >>>>\n\n"

# 當前目錄絕對路徑
current_path=$(pwd)

value=""
while [[ "$value" == "" ]]; do
    read -p "安裝路徑： " value
done

# 切換至安裝目錄
cd $value
# 安裝目錄絕對路徑
install_path=$(pwd)

# 若在安裝目錄下執行則停止執行
if [[ "$current_path" == "$install_path" ]]; then
    printf "\n\n請勿在安裝目錄下執行\n\n"
    exit 1
fi

ans=""
printf "\n安裝路徑為 ${install_path}\n"
read -p "是否正確？（是 請輸入大寫 Y，其他視為 否） " ans
if [[ "$ans" != "Y" ]]; then
    printf "\n結束執行\n\n"
    exit 1
fi

# 安裝目錄下建立 backup 目錄
if [[ ! -d backup ]]; then
    mkdir backup
fi
# 備份 .env 、 Caddyfile
printf "\n*****************************"
printf "\n備份 .env 、 Caddyfile"
printf "\n*****************************\n\n"
cp -f .env backup/
cp -f caddy/Caddyfile backup/




printf "\n*****************************"
printf "\n停止容器"
printf "\n*****************************\n\n"
./down.sh
printf "\n*****************************"
printf "\n停止容器完成"
printf "\n*****************************\n\n"

printf "\n*****************************"
printf "\n刪除舊檔"
printf "\n*****************************\n\n"
# 參考資料：
#    https://www.tecmint.com/delete-all-files-in-directory-except-one-few-file-extensions/
shopt -s extglob
rm -rfv !("db_data"|"logs"|"site"|"backup")
shopt -u extglob

printf "\n*****************************"
printf "\n下載新版"
printf "\n*****************************\n\n"
# 切換回下載並執行之 upgrade.sh 所在目錄
cd -
curl -L https://github.com/t301000/xoops-easy-dock/archive/master.zip -o xoops-easy-dock_new.zip

printf "\n*****************************"
printf "\n解壓縮"
printf "\n*****************************\n\n"
unzip xoops-easy-dock_new.zip
if [[ -d new ]]; then
    rm -rf new
fi
mv xoops-easy-dock-master new

# 複製新版檔案至安裝目錄
printf "\n*****************************"
printf "\n複製新版檔案"
printf "\n*****************************\n\n"
cp -Rfv new/* $value/

# 切換至安裝目錄
cd $value
# 用樣板檔產生新 .env
cp -f env-example-prod .env
# 切換至安裝目錄下 backup 目錄
cd backup
printf "\n*****************************"
printf "\n還原 Caddyfile"
printf "\n*****************************\n\n"
cp -f Caddyfile ../caddy/Caddyfile

printf "\n*****************************"
printf "\n還原環境設定 .env"
printf "\n*****************************\n\n"

# 還原 PHP_VERSION
printf "設定 PHP_VERSION"
CURRENT_PHP_VERSION=$(cat .env |grep ^PHP_VERSION=)
TEMPLATE_PHP_VERSION=$(cat ../.env |grep ^PHP_VERSION=)
sed -i "s/$TEMPLATE_PHP_VERSION/$CURRENT_PHP_VERSION/g" ../.env

# 還原 PHP_TAG
printf "\n設定 PHP_TAG"
CURRENT_PHP_TAG=$(cat .env |grep ^PHP_TAG=)
TEMPLATE_PHP_TAG=$(cat ../.env |grep ^PHP_TAG=)
if [[ "$CURRENT_PHP_TAG" == "" ]]; then
    # 若原來缺少此項設定，則採用樣板檔之設定
    CURRENT_PHP_TAG=$TEMPLATE_PHP_TAG
fi
sed -i "s/$TEMPLATE_PHP_TAG/$CURRENT_PHP_TAG/g" ../.env

# 還原 CADDY_TAG
printf "\n設定 CADDY_TAG"
CURRENT_CADDY_TAG=$(cat .env |grep ^CADDY_TAG=)
TEMPLATE_CADDY_TAG=$(cat ../.env |grep ^CADDY_TAG=)
if [[ "$CURRENT_CADDY_TAG" == "" ]]; then
    # 若原來缺少此項設定，則採用樣板檔之設定
    CURRENT_CADDY_TAG=$TEMPLATE_CADDY_TAG
fi
sed -i "s/$TEMPLATE_CADDY_TAG/$CURRENT_CADDY_TAG/g" ../.env

# 還原 MYSQL_TAG
printf "\n設定 MYSQL_TAG"
CURRENT_MYSQL_TAG=$(cat .env |grep ^MYSQL_TAG=)
TEMPLATE_MYSQL_TAG=$(cat ../.env |grep ^MYSQL_TAG=)
if [[ "${CURRENT_MYSQL_TAG}" == "" ]]; then
    # 若原來缺少此項設定，則採用樣板檔之設定
    CURRENT_MYSQL_TAG=$TEMPLATE_MYSQL_TAG
fi
sed -i "s/$TEMPLATE_MYSQL_TAG/$CURRENT_MYSQL_TAG/g" ../.env

# 還原 MYSQL 帳密資訊
printf "\n設定 MYSQL_DATABASE"
cat .env |grep ^MYSQL_DATABASE= >> ../.env
printf "\n設定 MYSQL_USER"
cat .env |grep ^MYSQL_USER= >> ../.env
printf "\n設定 MYSQL_PASSWORD"
cat .env |grep ^MYSQL_PASSWORD= >> ../.env
printf "\n設定 MYSQL_ROOT_PASSWORD"
cat .env |grep ^MYSQL_ROOT_PASSWORD= >> ../.env
printf "\n\n"
# 往上一層切換至安裝目錄
cd ..
printf "\n*****************************"
printf "\n請確認以下環境設定是否正確（應有 8 項）："
printf "\n*****************************\n\n"
cat .env |grep ^PHP_VERSION=
cat .env |grep ^PHP_TAG=
cat .env |grep ^CADDY_TAG=
cat .env |grep ^MYSQL_TAG=
cat .env |grep ^MYSQL_DATABASE=
cat .env |grep ^MYSQL_USER=
cat .env |grep ^MYSQL_PASSWORD=
cat .env |grep ^MYSQL_ROOT_PASSWORD=
printf "\n"
ans=""
read -p "是否正確？（是 請輸入大寫 Y，其他視為 否） " ans
if [[ "$ans" != "Y" ]]; then
    printf "\n請編輯 $install_path/.env 輸入正確設定才算完成更新。"
    printf "\n接著執行以下指令啟動容器\n"
    printf "      cd  $install_path\n"
    printf "      ./up.sh\n\n"
    exit 1
fi

printf "\n*****************************"
printf "\n設定確認正確，自動啟動容器"
printf "\n*****************************\n\n"

printf "\n*****************************"
printf "\n啟動容器"
printf "\n*****************************\n\n"
./up.sh
printf "\n*****************************"
printf "\n啟動容器完成"
printf "\n*****************************\n\n"

printf "\n*****************************"
printf "\n更新完成！！"
printf "\n*****************************\n\n"

exit 0