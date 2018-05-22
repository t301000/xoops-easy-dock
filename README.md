# XOOPS 輕鬆架 in Docker

## 這是啥？

為了在 [Docker](https://www.docker.com/) 環境中安裝 [XOOPS 輕鬆架](https://campus-xoops.tn.edu.tw/)，以 [Laradock](http://laradock.io/) 為基礎修改而來，可以快速完成 XOOPS 輕鬆架之安裝，並且經過簡單設定，即可完成 [Let's Encrypt](https://letsencrypt.org/) 的免費 SSL 憑證申請與自動更新。

## 包含元件

- [Caddy \- The HTTP/2 Web Server with Automatic HTTPS](https://caddyserver.com/)
- php-fpm
- MySQL

## 系統需求

- Debian based OS，建議使用 Ubuntu Server
- docker
- [docker-compose](https://github.com/docker/compose)

## 安裝步驟

### 安裝 Docker

依照 [https://get\.docker\.com](https://get.docker.com/) 的指示，依序輸入兩行指令。
```bash
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
```

完成後複製畫面上的指令執行。
```bash
# 此為範例
sudo usermod -aG docker YourAccount
```

登出再重新登入，執行以下指令，能看到 Client 與 Server 版本即安裝完成。
```bash
# 正常應能看到 Client 與 Server 的版本
docker version
```

### 安裝 docker-compose

先 sudo 成 root
```bash
sudo -s
```

到 [Releases · docker/compose · GitHub](https://github.com/docker/compose/releases) 複製執行以下指令。
```bash
# 範例，版本號可能不一樣
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

查看版本
```bash
docker-compose version
```

### 下載 xoops-easy-dock 並解壓縮

```bash
wget https://github.com/t301000/xoops-easy-dock/archive/master.zip
unzip master
```
解壓縮之後會有一個名稱為 xoops-easy-dock 之目錄。

### 重命名目錄

依需要將 xoops-easy-dock 重命名，如 xoops，此步驟可不做。
```bash
mv xoops-easy-dock xoops
```

### 進行設定

```bash
cd xoops
cp env-example .env
```
.env 是設定檔，一般只須設定資料庫資料。

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

### 進行容器啟動前之前置作業

```bash
./prepare.sh
```

此步驟會下載 XOOPS 輕鬆架，建立目錄並變更權限：
- db_data：此目錄下的 mysql 目錄存放資料庫檔案
- logs：此目錄下的 caddy 目錄存放 caddy 之 log 檔
- site：存放 XOOPS 程式

### 建置容器映像檔

第一次需要先建置容器映像檔，所需時間視網路連線狀況而定。
```bash
docker-compose build caddy
docker-compose build mysql
docker-compose build php-fpm
```

在建置映像檔時若遇到建置失敗，請重新建置，尤其是 php-fpm 。

若想要一次建置全部映像檔，可執行：
```bash
docker-compose build
```

### SSL 憑證

請務必先設定好 DNS，編輯 caddy 目錄下的 Caddyfile，找到：
```
0.0.0.0:80 {
    ...省略
}
```
將 0.0.0.0:80 改為如： www.example.com

在上一段中找到：
```
#tls self_signed
```
改為（記得 email 換成正確的）
```
tls user@gmail.com
```

以上設定即可自動申請憑證與自動更新

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

### 啟動容器

```bash
docker-compose up -d
```

### XOOPS 輕鬆架安裝

開啟瀏覽器進行 XOOPS 輕鬆架安裝
- 資料庫位址： mysql
- 資料庫名稱： .env 中 MYSQL_DATABASE 之設定值，預設為 default
- 資料庫帳號： .env 中 MYSQL_USER 之設定值，預設為 default
- 資料庫密碼： .env 中 MYSQL_PASSWORD 之設定值，預設為 secret
