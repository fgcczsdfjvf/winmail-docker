FROM debian:bullseye-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    procps \
    net-tools \
    curl \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 复制启动和调试脚本
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 下载和解压 Winmail
RUN wget https://github.com/fgcczsdfjvf/winmail-docker/releases/download/release-1.0/winmail-pro-5.2-0524-x86_64.tar.gz \
    && tar -xzf winmail-pro-5.2-0524-x86_64.tar.gz \
    && rm winmail-pro-5.2-0524-x86_64.tar.gz \
    && ls -la /app

# 设置权限
RUN if [ -d "/app/WinmailPro-5.2-0524" ]; then \
    chmod +x /app/WinmailPro-5.2-0524/install.sh \
    /app/WinmailPro-5.2-0524/winmail; \
    fi

# 暴露必要的端口
EXPOSE 80
EXPOSE 25
EXPOSE 110
EXPOSE 143

# 健康检查
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD netstat -tulpn | grep -q ':80' || exit 1

# 启动命令
CMD ["/app/start.sh"]
