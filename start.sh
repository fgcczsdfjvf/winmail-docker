#!/bin/bash
set -ex

# 启动一个简单的健康检查服务
(while true; do 
    echo "HTTP/1.1 200 OK\n\nOK" | nc -l -p 80
    sleep 1
done) &

# 运行调试脚本
echo "=== Initial Debug Info ==="
echo "=== Directory Contents ==="
ls -la /app
echo
echo "=== System Info ==="
uname -a
echo
echo "=== Process Status ==="
ps aux | grep winmail
echo
echo "=== Port Status ==="
netstat -tulpn

# 检查并创建目录
echo "Checking and extracting Winmail..."
cd /app
if [ ! -d "WinmailPro-5.2-0524" ]; then
    echo "Downloading Winmail..."
    wget https://github.com/fgcczsdfjvf/winmail-docker/releases/download/release-1.0/winmail-pro-5.2-0524-x86_64.tar.gz
    echo "Extracting files..."
    tar -xzf winmail-pro-5.2-0524-x86_64.tar.gz
    rm winmail-pro-5.2-0524-x86_64.tar.gz
fi

# 进入 Winmail 目录
cd WinmailPro-5.2-0524 || {
    echo "Failed to enter Winmail directory"
    exit 1
}

# 设置执行权限
chmod +x ./install.sh ./winmail

echo "Starting installation..."
./install.sh

echo "Starting Winmail..."
./winmail start

# 再次运行调试信息
echo "=== Post-Start Debug Info ==="
echo "=== Directory Contents ==="
ls -la /app
echo
echo "=== System Info ==="
uname -a
echo
echo "=== Process Status ==="
ps aux | grep winmail
echo
echo "=== Port Status ==="
netstat -tulpn

# 检查特定端口
echo "Checking specific ports..."
netstat -tulpn | grep -E ":80|:25|:110|:143" || true

# 定期检查服务状态
while true; do
    echo "=== Service Status Check $(date) ==="
    ps aux | grep winmail | grep -v grep || {
        echo "Winmail process not found, restarting..."
        ./winmail start
    }
    netstat -tulpn | grep -E ":80|:25|:110|:143" || {
        echo "Required ports not found, checking service..."
        ./winmail status
    }
    sleep 300  # 每5分钟检查一次
done &

# 保持容器运行
tail -f /dev/null
