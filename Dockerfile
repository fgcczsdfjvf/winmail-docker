FROM debian:bullseye-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    procps \
    net-tools \
    curl \  # 添加 curl 用于健康检查
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 下载和解压文件
RUN set -x \
    && wget https://github.com/fgcczsdfjvf/winmail-docker/releases/download/release-1.0/winmail-pro-5.2-0524-x86_64.tar.gz -O winmail.tar.gz \
    && tar -xzvf winmail.tar.gz \
    && rm winmail.tar.gz \
    && ls -la

# 创建启动脚本
RUN echo '#!/bin/bash\n\
set -x\n\
\n\
echo "=== 环境信息 ==="\n\
echo "当前目录: $(pwd)"\n\
echo "系统信息: $(uname -a)"\n\
echo "可用内存: $(free -h)"\n\
echo "磁盘空间: $(df -h)"\n\
\n\
echo "=== 目录内容 ==="\n\
ls -la /app\n\
\n\
if [ -d "/app/WinmailPro-5.2-0524" ]; then\n\
    echo "=== 进入 Winmail 目录 ==="\n\
    cd /app/WinmailPro-5.2-0524\n\
    \n\
    echo "=== 设置权限 ==="\n\
    chmod +x ./install.sh\n\
    chmod +x ./winmail\n\
    \n\
    echo "=== 执行安装脚本 ==="\n\
    ./install.sh\n\
    \n\
    echo "=== 启动 Winmail ==="\n\
    ./winmail start\n\
    \n\
    echo "=== 进程状态 ==="\n\
    ps aux | grep winmail\n\
    \n\
    echo "=== 网络状态 ==="\n\
    netstat -tulpn\n\
else\n\
    echo "错误: Winmail 目录未找到"\n\
    echo "当前目录内容:"\n\
    ls -la /app\n\
    exit 1\n\
fi\n\
\n\
# 保持容器运行并输出日志\n\
tail -f /app/WinmailPro-5.2-0524/logs/* /dev/null\n\
' > /app/start.sh && \
    chmod +x /app/start.sh

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

CMD ["/bin/bash", "/app/start.sh"]
