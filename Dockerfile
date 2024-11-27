FROM debian:bullseye-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    procps \
    net-tools \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 复制脚本文件
COPY debug.sh /app/debug.sh
COPY start.sh /app/start.sh

# 设置执行权限
RUN chmod +x /app/debug.sh /app/start.sh

# 暴露端口
EXPOSE 80 25 110 143

# 健康检查
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD netstat -tulpn | grep -q ':80' || exit 1

# 启动命令
CMD ["/app/start.sh"]
