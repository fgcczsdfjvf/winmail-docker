#!/bin/bash
set -ex

# 运行调试脚本
/app/debug.sh

# 检查并创建目录
echo "Checking and extracting Winmail..."
cd /app
if [ ! -d "WinmailPro-5.2-0524" ]; then
    wget https://github.com/fgcczsdfjvf/winmail-docker/releases/download/release-1.0/winmail-pro-5.2-0524-x86_64.tar.gz
    tar -xzf winmail-pro-5.2-0524-x86_64.tar.gz
    rm winmail-pro-5.2-0524-x86_64.tar.gz
fi

# 进入 Winmail 目录
cd WinmailPro-5.2-0524
chmod +x ./install.sh ./winmail

echo "Starting installation..."
./install.sh

echo "Starting Winmail..."
./winmail start

# 再次运行调试脚本
/app/debug.sh

# 检查端口
echo "Checking ports..."
netstat -tulpn | grep -E ":80|:25|:110|:143" || true

# 保持容器运行
tail -f /dev/null
