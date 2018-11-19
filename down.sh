###################################
#
#  所有容器 down
#
###################################
#!/bin/bash

docker_compose="/usr/local/bin/docker-compose"

echo ">>>> 正在停止並移除所有容器...."
echo ""

$docker_compose down


