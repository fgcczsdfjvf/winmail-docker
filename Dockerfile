FROM debian:bullseye-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    procps \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 使用 Release 链接下载文件（替换为你的实际 Release 链接）
RUN wget https://github.com/fgcczsdfjvf/winmail-docker/releases/download/release-1.0/winmail-pro-5.2-0524-x86_64.tar.gz -O winmail.tar.gz && \
    tar -xzvf winmail.tar.gz && \
    rm winmail.tar.gz && \
    # 验证文件是否存在
    ls -la

# 创建更安全的启动脚本
RUN echo '#!/bin/bash\n\
if [ -d "/app/WinmailPro-5.2-0524" ]; then\n\
    cd /app/WinmailPro-5.2-0524\n\
    chmod +x ./install.sh\n\
    chmod +x ./winmail\n\
    ./install.sh\n\
    ./winmail start\n\
else\n\
    echo "Winmail directory not found!"\n\
    ls -la /app\n\
    exit 1\n\
fi\n\
tail -f /dev/null' > /app/start.sh && \
    chmod +x /app/start.sh

# 确保端口正确暴露
EXPOSE 80

CMD ["/bin/bash", "/app/start.sh"]
