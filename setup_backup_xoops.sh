#!/bin/bash
###########################
# 用途：
#   產生備份 xoops 之腳本
#   設定備份排程 for root
###########################

#######################
#    變數區
#######################
# 樣板檔
TPL_FILE="backup_xoops.tpl"
# 產出之腳本檔
SH_FILE="backup_xoops.sh"
# root 之 crontab
ROOT_CRONTAB="/var/spool/cron/crontabs/root"
# 複製檔與暫存檔
ROOT_CRONTAB_COPY="/tmp/root_crontab_copy"
ROOT_CRONTAB_TMP="/tmp/root_crontab_tmp"


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

# 產生備份腳本檔
generateBackupScript() {
    printf "\n\n"
    printf "***** 產生備份腳本檔 *****"
    printf "\n\n"
    pause ">>> 按任意鍵繼續 或 Ctrl + C 中斷...."

    printf "\n\n"
    read -p "備份檔保留幾份？ [ 輸入數字，預設 7 ] " keep_count
    if [[ "$keep_count" == "" ]]; then
        keep_count=7
    fi

    cp $TPL_FILE $SH_FILE && chmod +x $SH_FILE

    # 參考 https://stackoverflow.com/questions/27787536/how-to-pass-a-variable-containing-slashes-to-sed
    # 因為變數值為路徑含有 /，所以將 sed 之分隔符號換成其他符號
    sed -i "s:_INSTALL_PATH:$PWD:g" $SH_FILE
    sed -i "s:_MY_USERNAME:$USER:g" $SH_FILE
    sed -i "s:_KEEP_COUNT:$keep_count:g" $SH_FILE

    printf "\n"
    printf "備份腳本檔已產生："
    printf "\n"
    printf "    ${PWD}/${SH_FILE}"
    printf "\n\n"
    printf "備份檔存放目錄為："
    printf "\n"
    printf "    $(dirname ${PWD})/xoops_backup/"
    printf "\n\n"
    printf "備份檔保留 ${keep_count} 份"
    printf "\n\n"
    pause ">>> 按任意鍵繼續...."
}

# 設定備份排程 for root
setupCrontabForRoot(){
    printf "\n\n"
    printf "***** 設定備份排程 *****"
    printf "\n\n"
    printf "會先清除原有之備份排程（有的話）"
    printf "\n\n"
    printf "將以 root 執行備份，每日備份一次"
    printf "\n\n"
    pause ">>> 按任意鍵繼續 或 Ctrl + C 中斷...."

    printf "\n\n"
    read -p "每天幾點執行備份？ [ 0 - 23，預設 1 => 凌晨 1 點] " ans
    if [[ "$ans" == "" ]]; then
        ans=1
    fi

    # 複製原有排程
    sudo crontab -l > $ROOT_CRONTAB_COPY
    # 移除原有的備份排程
    grep -v -E "${PWD}/${SH_FILE}|xoops備份排程" $ROOT_CRONTAB_COPY > $ROOT_CRONTAB_TMP
    # 加入新的備份排程
    echo "# xoops備份排程，每天 ${ans} 點備份" >> $ROOT_CRONTAB_TMP
    echo "0 ${ans} * * * ${PWD}/${SH_FILE}" >> $ROOT_CRONTAB_TMP
    # 由暫存檔倒入排程
    sudo crontab -u root $ROOT_CRONTAB_TMP
    # 刪除複製檔與暫存檔
    rm -rf $ROOT_CRONTAB_TMP $ROOT_CRONTAB_COPY

    printf "\n\n"
    printf "備份排程設定完成，每天 ${ans} 點備份一次"
    printf "\n\n"
    pause ">>> 按任意鍵繼續...."
}

# 查看 root 的排程
listCrontabForRoot() {
    printf "\n\n"
    printf "***** root 的排程 *****"
    printf "\n\n"
    sudo crontab -u root -l
    printf "\n\n"
    pause ">>> 按任意鍵繼續...."
}

# 顯示選單
showMenu() {
    printf "\n\n"
    printf "#########################################"
    printf "\n#"
    printf "\n#    產生備份腳本檔與設定備份排程"
    printf "\n#"
    printf "\n#########################################"
    printf "\n\n"
    printf "1 產生備份腳本檔"
    printf "\n"
    printf "2 設定備份排程"
    printf "\n"
    printf "3 查看 root 的排程"
    printf "\n"
    printf "q 離開"
    printf "\n\n"

    read -p "請輸入 [ 預設： q 離開 ] " choice
    if [[ "$choice" == "" ]] || [[ "$choice" == "q" ]] || [[ "$choice" == "Q" ]]; then
        printf "\n"
        exit 0
    fi

    # 1 產生備份腳本檔
    if [[ "$choice" == "1" ]]; then
        generateBackupScript
        clear
        showMenu
    fi

    # 2 設定備份排程
    if [[ "$choice" == "2" ]]; then
        setupCrontabForRoot
        clear
        showMenu
    fi

    # 3 查看 root 的排程
    if [[ "$choice" == "3" ]]; then
        listCrontabForRoot
        clear
        showMenu
    fi

    # 其他
    clear
    showMenu
}


#######################
#    執行區
#######################

showMenu
