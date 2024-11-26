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
cd /app/WinmailPro-5.2-0524
chmod +x ./install.sh ./winmail
./install.sh
./winmail start
tail -f /dev/null
EOF

RUN chmod +x /app/start.sh

EXPOSE 80

CMD ["/app/start.sh"]
