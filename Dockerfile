FROM debian:bullseye-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    procps \
    net-tools \
    tar \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 下载并解压 Winmail Pro 5.2
RUN wget http://www.winmail.cn/download/WinmailPro-5.2-0524.tar.gz && \
    tar -zxf WinmailPro-5.2-0524.tar.gz && \
    rm WinmailPro-5.2-0524.tar.gz

# 进入 Winmail 目录并安装
WORKDIR /app/WinmailPro-5.2-0524
RUN ./install.sh

# 暴露需要的端口
EXPOSE 80 110 143 25 465 995 993

# 启动 Winmail
CMD ["./winmail", "start"]
