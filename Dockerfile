FROM debian:bullseye-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    procps \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 下载和解压 Winmail
RUN wget https://github.com/fgcczsdfjvf/winmail-docker/releases/download/release-1.0/winmail-pro-5.2-0524-x86_64.tar.gz \
    && tar -xzf winmail-pro-5.2-0524-x86_64.tar.gz \
    && rm winmail-pro-5.2-0524-x86_64.tar.gz

# 创建启动脚本
COPY <<'EOF' /app/start.sh
#!/bin/bash
set -e

cd /app/WinmailPro-5.2-0524
chmod +x ./install.sh ./winmail

echo "Starting installation..."
./install.sh

echo "Starting Winmail..."
./winmail start

echo "Checking process status..."
ps aux | grep winmail

echo "Checking port status..."
netstat -tulpn

# 保持容器运行
tail -f /dev/null
EOF

RUN chmod +x /app/start.sh

# 明确暴露端口
EXPOSE 80
EXPOSE 25
EXPOSE 110
EXPOSE 143

# 健康检查
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD netstat -tulpn | grep -q ':80' || exit 1

CMD ["/app/start.sh"]
