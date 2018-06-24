#!/bin/bash
#
# 設定 Caddyfile
#

# 樣板檔
TPL_FILE="caddy/Caddyfile.tpl"

# Caddyfile
CADDYFILE="caddy/Caddyfile"

# 例：www.demo.com
FQDN="0.0.0.0:80"

# 例：user@demo.com
EMAIL=""

# 正式環境
TLS=""

# 練習模式
TLS_TEST_1=""
TLS_TEST_2=""
TLS_TEST_3=""

# ip to https://FQDN
FORCE_HTTPS_1=""
FORCE_HTTPS_2=""
FORCE_HTTPS_3=""


exit_when_fqdn_not_exist() {
    if [[ $FQDN == "0.0.0.0:80" ]]; then
        printf "\n錯誤：沒有設定正確網址\n\n"
        exit
    fi
}

exit_when_email_not_exist() {
    if [[ $EMAIL == "" ]]; then
        printf "\n錯誤：沒有設定 Email\n\n"
        exit
    fi
}

enable_tls() {
    TLS="tls $EMAIL"
}

disable_tls() {
    TLS=""
}

enable_tls_test() {
    TLS_TEST_1="tls $EMAIL {"
    TLS_TEST_2="ca https://acme-staging-v02.api.letsencrypt.org/directory"
    TLS_TEST_3="}"
}

disable_tls_test() {
    TLS_TEST_1=""
    TLS_TEST_2=""
    TLS_TEST_3=""
}

enable_force_https() {
    FORCE_HTTPS_1=":80 {"
    FORCE_HTTPS_2="redir https://$FQDN{uri}"
    FORCE_HTTPS_3="}"
}

disable_force_https() {
    FORCE_HTTPS_1=""
    FORCE_HTTPS_2=""
    FORCE_HTTPS_3=""
}

#### 開始 ####

echo "***** 設定 caddy server *****"
printf "按下 Ctrl + c 可中斷\n\n"

RESET_DEFAULT=false
read -p "重設 Caddyfile 回預設值：(預設： N)[y/N]  " value
if [[ "$value" == "y" ]] || [[ "$value" == "Y" ]]; then
    RESET_DEFAULT=true
fi 
if [[ $RESET_DEFAULT == true ]]; then
    cp ${CADDYFILE}.orig $CADDYFILE
    echo "Caddyfile 已重設為預設值"
    exit
fi

#### 以下開始設定 ####

read -p "網址：(預設： 0.0.0.0:80)  " value
if [[ "$value" != "" ]]; then
    FQDN=$value
fi

read -p "Email：  " value
if [[ "$value" != "" ]]; then
    EMAIL=$value
fi

ssl_mode=false
read -p "正式啟用 SSL：(預設： N)[y/N]  " enable
if [[ "$enable" == "y" ]] || [[ "$enable" == "Y" ]]; then
    exit_when_fqdn_not_exist
    exit_when_email_not_exist
    enable_tls
    disable_tls_test
    ssl_mode=true
fi

ssl_test=false
if [[ $ssl_mode == false ]]; then
    read -p "測試啟用 SSL：(預設： N)[y/N]  " enable_test
    if [[ "$enable_test" == "y" ]] || [[ "$enable_test" == "Y" ]]; then
        exit_when_fqdn_not_exist
        exit_when_email_not_exist
        disable_tls
        enable_tls_test
        ssl_test=true
    fi
fi


ip_to_https=false
if [[ $ssl_mode == true ]] || [[ $ssl_test == true ]]; then
    read -p "強迫 http://ip 轉向 https://$FQDN：(預設： N)[y/N]  " enable_ip_to_https
    if [[ "$enable_ip_to_https" == "y" ]] || [[ "$enable_ip_to_https" == "Y" ]]; then
        # exit_when_fqdn_not_exist
        enable_force_https
        ip_to_https=true
    fi
fi


# echo $FQDN
# echo $EMAIL
# echo $TLS
# echo $TLS_TEST_1
# echo $TLS_TEST_2
# echo $TLS_TEST_3
# echo $FORCE_HTTPS_1
# echo $FORCE_HTTPS_2
# echo $FORCE_HTTPS_3

# exit

DATE=`date '+%Y%m%d%H%M%S'`

echo "備份 $CADDYFILE => ${CADDYFILE}.bak-${DATE}"
cp $CADDYFILE ${CADDYFILE}.bak-${DATE}

echo "產生 $CADDYFILE..."

while read a ; do
    keep=true
    if [[ "$a" == "_FQDN_"* ]]; then
        echo ${a/_FQDN_/$FQDN}
        keep=false
    fi

    if [[ "$a" == "_TLS_" ]]; then
        # echo ${a/_TLS_TEST_/$TLS_TEST}
        echo $TLS
        keep=false
    fi

    if [[ "$a" == "_TLS_TEST_1_" ]]; then
        # echo ${a/_TLS_TEST_/$TLS_TEST}
        echo $TLS_TEST_1
        keep=false
    fi

    if [[ "$a" == "_TLS_TEST_2_" ]]; then
        echo $TLS_TEST_2
        keep=false
    fi

    if [[ "$a" == "_TLS_TEST_3_" ]]; then
        echo $TLS_TEST_3
        keep=false
    fi

    if [[ "$a" == "_FORCE_HTTPS_1_" ]]; then
        echo $FORCE_HTTPS_1
        keep=false
    fi

    if [[ "$a" == "_FORCE_HTTPS_2_" ]]; then
        echo $FORCE_HTTPS_2
        keep=false
    fi

    if [[ "$a" == "_FORCE_HTTPS_3_" ]]; then
        echo $FORCE_HTTPS_3
        keep=false
    fi

    if [[ $keep == true ]]; then
        echo "$a"
    fi
    
done < $TPL_FILE > $CADDYFILE

printf "caddy server 設定完成！！\n\n"
echo "執行以下指令可重新啟動 caddy server container :"
echo "    docker-compose restart caddy"
printf "\n"
