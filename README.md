# XOOPS 輕鬆架 in Docker

## 這是啥？

為了在 [Docker](https://www.docker.com/) 環境中安裝 [XOOPS 輕鬆架](https://campus-xoops.tn.edu.tw/)，以 [Laradock](http://laradock.io/) 為基礎修改而來，可以快速完成 XOOPS 輕鬆架之安裝，並且經過簡單設定，即可完成 [Let's Encrypt](https://letsencrypt.org/) 的免費 SSL 憑證申請與自動更新。

## 包含元件

- [Caddy \- The HTTP/2 Web Server with Automatic HTTPS](https://caddyserver.com/)
- php-fpm
- MySQL

## 安裝步驟

wget https://github.com/t301000/laravel-stack/archive/master.zip

unzip master

mv xoops-easy-dock xoops

cd xoops

cp env-example .env

編輯 .env

./prepare.sh

docker-compose up -d

開啟瀏覽器進行 XOOPS 輕鬆架安裝
