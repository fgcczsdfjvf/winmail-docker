FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 在容器构建时下载 WinMail
RUN wget [WinMail官方下载链接]

# 添加配置和启动脚本
COPY start.sh /app/
RUN chmod +x /app/start.sh

CMD ["./start.sh"]
