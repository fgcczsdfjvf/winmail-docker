FROM php:8.1-apache

WORKDIR /var/www/html

# 安装必要的扩展和工具
RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 复制安装脚本
COPY install.sh /var/www/html/
RUN chmod +x /install.sh

# 运行安装脚本
RUN ./install.sh

# 配置 Apache
RUN echo "Listen \${PORT}" > /etc/apache2/ports.conf
RUN sed -i 's/80/\${PORT}/g' /etc/apache2/sites-available/000-default.conf

# 启动 Apache
CMD apache2-foreground
