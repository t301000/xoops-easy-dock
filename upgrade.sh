#!/bin/bash
printf "\n<<<< xoops-easy-dock 更新 >>>>\n\n"

value=""
while [[ "$value" == "" ]]; do
    read -p "安裝路徑： " value
done

ans=""
printf "\n安裝路徑為 ${value}\n"
read -p "是否正確？（請輸入大寫 Y） " ans
if [[ "$ans" != "Y" ]]; then
    printf "\n結束執行\n\n"
    exit 1
fi

cd $value
if [[ ! -d backup ]]; then
    mkdir backup
fi

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

printf "\n*****************************"
printf "\n複製新版檔案"
printf "\n*****************************\n\n"
cp -Rfv new/* $value/

printf "\n*****************************"
printf "\n還原設定"
printf "\n*****************************\n\n"
cd $value
cp -f env-example-prod .env
cd backup
cat .env |grep ^MYSQL_DATABASE= >> ../.env
cat .env |grep ^MYSQL_USER= >> ../.env
cat .env |grep ^MYSQL_PASSWORD= >> ../.env
cat .env |grep ^MYSQL_ROOT_PASSWORD= >> ../.env
cp -f Caddyfile ../caddy/Caddyfile

printf "\n*****************************"
printf "\n啟動容器"
printf "\n*****************************\n\n"
cd ..
./up.sh
printf "\n*****************************"
printf "\n啟動容器完成"
printf "\n*****************************\n\n"

printf "\n*****************************"
printf "\n更新完成！！"
printf "\n*****************************\n\n"
exit 0