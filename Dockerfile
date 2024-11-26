FROM debian:bullseye-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    procps \
    net-tools \
    tar \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 下载并解压 Winmail
RUN wget http://www.winmail.cn/download/WinmailPro-5.2-0524.tar.gz && \
    tar -zxf WinmailPro-5.2-0524.tar.gz && \
    rm WinmailPro-5.2-0524.tar.gz

# 设置启动脚本
RUN echo '#!/bin/bash\n\
cd /app/WinmailPro-5.2-0524\n\
./install.sh\n\
./winmail start\n\
tail -f /dev/null' > /app/start.sh && \
    chmod +x /app/start.sh

EXPOSE 80

CMD ["/app/start.sh"]
