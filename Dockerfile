FROM php:8.1-apache

WORKDIR /var/www/html

# 安装必要的扩展和工具
RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 复制安装脚本
COPY install.sh /var/www/html/install.sh
RUN chmod +x /var/www/html/install.sh

# 运行安装脚本
RUN /var/www/html/install.sh

# 配置 Apache
RUN echo "Listen \${PORT}" > /etc/apache2/ports.conf
RUN sed -i 's/80/\${PORT}/g' /etc/apache2/sites-available/000-default.conf

# 设置权限
RUN chown -R www-data:www-data /var/www/html

# 启动 Apache
CMD apache2-foreground
