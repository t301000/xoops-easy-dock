# XOOPS 輕鬆架 in Docker

## 這是啥？

為了在 [Docker](https://www.docker.com/) 環境中安裝 [XOOPS 輕鬆架](https://campus-xoops.tn.edu.tw/)，以 [Laradock](http://laradock.io/) 為基礎修改而來，可以快速完成 XOOPS 輕鬆架之安裝，並且經過簡單設定，即可完成 [Let's Encrypt](https://letsencrypt.org/) 的免費 SSL 憑證申請與自動更新。

## 包含元件

- [Caddy \- The HTTP/2 Web Server with Automatic HTTPS](https://caddyserver.com/)
- php-fpm
- MySQL

## 系統需求

- Debian based OS，建議使用 Ubuntu Server
- CentOS 7
- curl
- unzip

```bash
# Debian based OS
sudo apt install -y unzip curl

# CentOS 7
sudo yum install -y unzip curl
```

## 安裝步驟

### 1. 下載 xoops-easy-dock 並解壓縮

```bash
curl -L https://github.com/t301000/xoops-easy-dock/archive/master.zip -o master.zip
unzip master.zip
```
解壓縮之後會有一個名稱為 xoops-easy-dock-master 之目錄。

### 2. 重命名目錄

依需要將 xoops-easy-dock-master 目錄重命名，如 xoops ，此步驟可不做。
```bash
mv xoops-easy-dock-master xoops
```

### 3. 安裝 Docker 與 docker-compose

```bash
cd xoops
./install-docker.sh
```

登出再重新登入，執行以下指令，能看到 Client 與 Server 版本則 Docker 安裝完成。
```bash
docker version
```

執行以下指令，查看 docker-compose [版本](https://github.com/docker/compose/releases)。
```bash
docker-compose version
```

### 4. 進行容器啟動前之前置作業

```bash
./prepare.sh
```

此步驟會下載 XOOPS 輕鬆架，建立目錄並變更權限：
- db_data：此目錄會存放 ssl 證書相關檔案與資料庫檔案（ mysql 目錄）
- logs：此目錄下的 caddy 目錄存放 caddy 之 log 檔
- site：存放 XOOPS 程式

### 5. 進行設定

環境設定檔為 .env ，若不存在則執行：
```bash
cp env-example .env
```

.env 一般只須設定資料庫資料。

找到以下區塊：
```
### MYSQL #################################################

MYSQL_VERSION=8.0.11
MYSQL_DATABASE=default
MYSQL_USER=default
MYSQL_PASSWORD=secret
MYSQL_PORT=3306
MYSQL_ROOT_PASSWORD=root
MYSQL_ENTRYPOINT_INITDB=./mysql/docker-entrypoint-initdb.d
```

設定以下項目：
- MYSQL_DATABASE：欲使用的資料庫名稱，預設為 default
- MYSQL_USER：欲使用的資料庫帳號，預設為 default
- MYSQL_PASSWORD：欲使用的資料庫密碼，預設為 secret
- MYSQL_ROOT_PASSWORD：設定 root 密碼，預設為 root

### 6. 網站 SSL 憑證

請務必先設定好 DNS，編輯 caddy 目錄下的 Caddyfile。

```bash
vim caddy/Caddyfile
```

#### 6.1
找到：
```
0.0.0.0:80 {
    ...省略
}
```
將 0.0.0.0:80 改為如： www.example.com

#### 6.2
這個步驟是啟動 https 的關鍵，在上一段中找到：
```
#tls self_signed
```
改為（記得 email 換成正確的）
```
tls user@gmail.com
```

以上設定即可自動申請憑證與自動更新，正式上線前才做。

因為 [Let's Encrypt](https://letsencrypt.org/) 的憑證申請有流量限制（[參考文章](http://cctg.blogspot.tw/2016/08/lets-encrypt-ssl-key.html)，[官方文件 Rate Limits](https://letsencrypt.org/docs/rate-limits/)），練習時為了避免同一個 FQDN 超過限制，造成正式上線時無法即時申請到憑證，可以啟用如下設定(記得 email 換成正確的，正式上線前記得註解掉)，此設定下 https 連線會標示為不安全：
```
tls user@gmail.com {
    ca https://acme-staging-v02.api.letsencrypt.org/directory
}
```

#### 6.3
若想要將以 server ip 連線之 http 連線轉至 https，則繼續進行以下設定。
找到：
```
#:80 {
#    redir https://www.example.com{uri}
#}
```
改為（記得將 www.example.com 改掉）
```
:80 {
    redir https://www.example.com{uri}
}
```

### 7. 啟動容器

```bash
docker-compose up -d
```

### 8. XOOPS 輕鬆架安裝

開啟瀏覽器進行 XOOPS 輕鬆架安裝
- 資料庫位址： mysql
- 資料庫名稱： .env 中 MYSQL_DATABASE 之設定值，預設為 default
- 資料庫帳號： .env 中 MYSQL_USER 之設定值，預設為 default
- 資料庫密碼： .env 中 MYSQL_PASSWORD 之設定值，預設為 secret

## 資料庫管理

XOOPS 輕鬆架內建 [Adminer](https://www.adminer.org/) 管理資料庫，網址為：

http(s)://YOUR_SERVER/modules/tad_adm/pma.php

- 伺服器：mysql
- 帳號： .env 中 MYSQL_USER 之設定值，預設為 default
- 密碼： .env 中 MYSQL_PASSWORD 之設定值，預設為 secret
- 資料庫： .env 中 MYSQL_DATABASE 之設定值，預設為 default，可不輸入
