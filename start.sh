#!/bin/bash

# 设置环境变量
export PORT=${PORT:-3000}

# 启动Winmail服务
exec docker run \
    -p ${PORT}:80 \
    -e TZ=Asia/Shanghai \
    --name winmail \
    ${DOCKER_USERNAME}/winmail-docker:latest
