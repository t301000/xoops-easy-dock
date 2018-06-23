#!/bin/bash

ans=""
read -p "！！注意！！檔案一經刪除則無法回復。是否執行清除動作？[yes/N]" ans
if [ "${ans}" != "yes" ];then
    exit 0
fi

ans=""
read -p "是否清除資料庫檔案？[y/N]" ans
if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
  # sudo rm -rf db_data/mysql/*
  sudo rm -rf db_data/mysql/*
  echo "***** 資料庫檔案清除完畢 *****"
fi

ans=""
read -p "是否清除 web log 檔案？[y/N]" ans
if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
  sudo rm -rf logs/caddy/*
  echo "***** web log 檔案清除完畢 *****"
fi

ans=""
read -p "是否清除 網站 檔案？[y/N]" ans
if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
  sudo rm -rf site
  echo "***** 網站 檔案清除完畢 *****"
fi

ans=""
read -p "是否清除 環境設定檔 .env ？[y/N]" ans
if [ "${ans}" == "y" ] || [ "${ans}" == "Y" ];then
  sudo rm -f .env
  echo "***** 環境設定檔 .env 清除完畢 *****"
fi

printf "\n***** 清除動作已執行完畢 *****\n\n"
