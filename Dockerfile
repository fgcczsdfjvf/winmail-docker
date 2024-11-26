FROM php:8.1-apache

WORKDIR /var/www/html

# 安装必要的扩展和工具
RUN apt-get update && apt-get install -y \
    wget \
    libzip-dev \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

# 复制并运行安装脚本
COPY install.sh /var/www/html/install.sh
RUN chmod +x /var/www/html/install.sh
RUN /var/www/html/install.sh

# 配置 Apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN echo "Listen \${PORT}" > /etc/apache2/ports.conf
RUN a2enmod rewrite

# 设置权限
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# 启动命令
CMD sed -i "s/\${PORT}/$PORT/g" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf && apache2-foreground
