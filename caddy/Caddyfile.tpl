# Docs: https://caddyserver.com/docs/caddyfile
_FQDN_ {
    root /var/www/public
    fastcgi / php-fpm:9000 php {
        index index.php
    }

    # To handle .html extensions with laravel change ext to
    # ext / .html

    #rewrite {
    #    to {path} {path}/ /index.php?{query}
    #}
    gzip
    browse
    log /var/log/caddy/access.log
    errors /var/log/caddy/error.log
    # Uncomment to enable TLS (HTTPS)
    # Change the first list to listen on port 443 when enabling TLS
    #tls self_signed
    
    _TLS_

    # 練習啟用 ssl 時請將以下 3 行取消註解並設定 email ，上線前再將其註解
    # 此模式下請以無痕模式開啟網頁
    #tls user@gmail.com {
    #    ca https://acme-staging-v02.api.letsencrypt.org/directory
    #}

    _TLS_TEST_1_
    _TLS_TEST_2_
    _TLS_TEST_3_

    # To use Lets encrpt tls with a DNS provider uncomment these
    # lines and change the provider as required
    #tls {
    #  dns cloudflare
    #}

    header / {
        # 隱藏 server 資訊
        -Server
        
        # Enable HTTP Strict Transport Security (HSTS) to force clients to always
        # connect via HTTPS (do not use if only testing)
        Strict-Transport-Security "max-age=31536000; includeSubDomains"

        # Enable cross-site filter (XSS) and tell browser to block detected attacks
        X-XSS-Protection "1; mode=block"

        # Prevent some browsers from MIME-sniffing a response away from the declared Content-Type
        X-Content-Type-Options "nosniff"

        # Disallow the site to be rendered within a frame (clickjacking protection)
        #X-Frame-Options "DENY"
        
        # Referrer-Policy "no-referrer" ==> 可能會造成 iframe 內容出不來
        Referrer-Policy "strict-origin-when-cross-origin"
    }
}

# 將 http 連線轉向 https
#:80 {
#    redir https://www.example.com{uri}
#}

_FORCE_HTTPS_1_
_FORCE_HTTPS_2_
_FORCE_HTTPS_3_

#laradock1.demo:80 {
#    root /var/www/public
    # Create a Webhook in git.
    #git {
	#repo https://github.com/xxx/xxx
    #    path /home/xxx
    #    #interval 60
    #    hook  webhook laradock
    #    hook_type   generic
    #}

#}

#laradock2.demo:80 {
    # Create a Proxy and cors.
    #proxy domain.com
	#cors
#}
