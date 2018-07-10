#!/bin/bash
#
# 設定 Caddyfile
#

# 樣板檔
TPL_FILE="caddy/Caddyfile.tpl"
# 暫存檔
TEMP_FILE="caddy/Caddyfile.tmp"

# Caddyfile
CADDYFILE="caddy/Caddyfile"

# 例：www.demo.com
FQDN="0.0.0.0:80"

# 例：user@demo.com
EMAIL=""

# 正式環境
TLS_PROD=""

# 練習模式
TLS_TEST=""

# ip to https://FQDN
FORCE_HTTPS=""


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
    TLS_PROD="tls $EMAIL"
}

disable_tls() {
    TLS_PROD=""
}

enable_tls_test() {
    TLS_TEST="tls $EMAIL {\n\
        ca https:\/\/acme-staging-v02.api.letsencrypt.org\/directory\n\
    }"
}

disable_tls_test() {
    TLS_TEST=""
}

enable_force_https() {
    FORCE_HTTPS=":80 {\n    redir https:\/\/$FQDN{uri}\n}"
}

disable_force_https() {
    FORCE_HTTPS=""
}

#### 開始 ####

# 顯示說明
clear
echo "//////////////////////////////////////////////////"
echo "此步驟設定網頁伺服器 Caddy"
echo "若要一併啟用 SSL，務必先設定好 DNS 之正解"
echo ""
echo "設定檔位於："
echo "    ${PWD}/caddy/Caddyfile"
echo "//////////////////////////////////////////////////"
echo ""

read -p "是否繼續？(預設： Y)[Y/n] " value
if [[ "${value}" != "n" ]] && [[ "${value}" != "N" ]]; then

    echo "***** 設定 caddy server *****"
    printf "按下 Ctrl + c 可中斷\n\n"

    RESET_DEFAULT=false
    read -p "重設 Caddyfile 回初始預設值：(預設： N)[y/N]  " value
    if [[ "$value" == "y" ]] || [[ "$value" == "Y" ]]; then
        RESET_DEFAULT=true
    fi
    if [[ $RESET_DEFAULT == true ]]; then
        cp ${CADDYFILE}.orig $CADDYFILE
        echo "Caddyfile 已重設為預設值"
        exit
    fi

    #### 以下開始設定 ####
    echo ""
    echo "//////////////////////////////////////////////////"
    echo "若未設定好 DNS 之正解，請先採預設值"
    echo "待日後設定好 DNS 之正解，再執行此步驟重新設定"
    echo ""
    echo "若已設定 DNS 正解，則依設定於此處輸入，例如："
    echo "    demo.yljh.ntpc.edu.tw"
    echo "//////////////////////////////////////////////////"
    echo ""

    read -p "網址：(預設： 0.0.0.0:80)  " value
    if [[ "$value" != "" ]]; then
        FQDN=$value
    fi

    if [[ "$FQDN" != "0.0.0.0:80" ]]; then

        read -p "網站管理員之 Email：  " value
        if [[ "$value" != "" ]]; then
            EMAIL=$value
        fi

        ssl_mode=false
        read -p "是否正式啟用 SSL：(預設： N)[y/N]  " enable
        if [[ "$enable" == "y" ]] || [[ "$enable" == "Y" ]]; then
            exit_when_fqdn_not_exist
            exit_when_email_not_exist
            enable_tls
            disable_tls_test
            ssl_mode=true
        fi

        ssl_test=false
        if [[ $ssl_mode == false ]]; then
            read -p "是否啟用 SSL 測試模式：(預設： N)[y/N]  " enable_test
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
            echo ""
            echo "//////////////////////////////////////////////////"
            echo "若啟用 SSL，則無法以 ip 連線"
            echo "此項設定是將 http://ip 之連線強制轉向至 https://$FQDN"
            echo "//////////////////////////////////////////////////"
            echo ""

            read -p "強迫 http://ip 轉向 https://$FQDN：(預設： N)[y/N]  " enable_ip_to_https
            if [[ "$enable_ip_to_https" == "y" ]] || [[ "$enable_ip_to_https" == "Y" ]]; then
                # exit_when_fqdn_not_exist
                enable_force_https
                ip_to_https=true
            fi
        fi

    fi

    DATE=`date '+%Y%m%d%H%M%S'`

    echo "備份 $CADDYFILE => ${CADDYFILE}.bak-${DATE}"
    cp $CADDYFILE ${CADDYFILE}.bak-${DATE}

    echo "產生 $CADDYFILE..."

    cp $TPL_FILE $TEMP_FILE

    sed -i "s/_FQDN_/$FQDN/g" $TEMP_FILE
    sed -i "s/_TLS_PROD_/$TLS_PROD/g" $TEMP_FILE
    sed -i "s/_TLS_TEST_/$TLS_TEST/g" $TEMP_FILE
    sed -i "s/_FORCE_HTTPS_/$FORCE_HTTPS/g" $TEMP_FILE

    mv $TEMP_FILE $CADDYFILE

    printf "caddy server 設定完成！！\n\n"
    echo "///////////////////////////////////////////////"
    echo "若 Caddy 容器啟動之後重新設定過"
    echo "則執行以下指令可重新啟動 Caddy 容器："
    echo "    cd ${PWD}"
    echo "    docker-compose restart caddy"
    echo "///////////////////////////////////////////////"
    printf "\n"
fi
