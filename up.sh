###################################
#
#  啟動容器
#
#  up.sh [services]
#  可用 service : caddy php-fpm mysql
#  service 可多個，空格分隔
#
###################################
#!/bin/bash

docker_compose="/usr/local/bin/docker-compose"

if [[ $@ == "" ]]; then
    echo ">>>> 正在啟動所有容器...."
else
    echo ">>>> 正在啟動容器 $@ ...."
fi
echo ""

$docker_compose up -d $@


