#!/bin/bash
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

sudo rm -rf site
echo "***** 檔案清除完畢 *****"
