FROM debian:bullseye-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    procps \
    net-tools \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 下载和解压 Winmail
RUN wget https://github.com/fgcczsdfjvf/winmail-docker/releases/download/release-1.0/winmail-pro-5.2-0524-x86_64.tar.gz \
    && tar -xzf winmail-pro-5.2-0524-x86_64.tar.gz \
    && rm winmail-pro-5.2-0524-x86_64.tar.gz

# 创建调试脚本
RUN echo '#!/bin/bash\n\
echo "=== System Info ==="\n\
uname -a\n\
echo\n\
echo "=== Network Info ==="\n\
ip addr\n\
echo\n\
echo "=== Port Status ==="\n\
netstat -tulpn\n\
echo\n\
echo "=== Process Status ==="\n\
ps aux | grep winmail\n\
' > /app/debug.sh \
    && chmod +x /app/debug.sh

# 创建启动脚本
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# 运行调试脚本\n\
/app/debug.sh\n\
\n\
cd /app/WinmailPro-5.2-0524\n\
chmod +x ./install.sh ./winmail\n\
\n\
echo "Starting installation..."\n\
./install.sh\n\
\n\
echo "Starting Winmail..."\n\
./winmail start\n\
\n\
# 再次运行调试脚本\n\
/app/debug.sh\n\
\n\
# 检查端口\n\
echo "Checking ports..."\n\
netstat -tulpn | grep -E ":80|:25|:110|:143"\n\
\n\
# 保持容器运行并输出日志\n\
tail -f /dev/null\n\
' > /app/start.sh \
    && chmod +x /app/start.sh

# 暴露必要的端口
EXPOSE 80
EXPOSE 25
EXPOSE 110
EXPOSE 143

# 健康检查
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

# 设置启动命令
CMD ["/app/start.sh"]
