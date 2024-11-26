FROM php:8.1-apache

WORKDIR /var/www/html

# 安装必要的扩展
RUN apt-get update && apt-get install -y \
    libzip-dev \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

# 清理默认文件
RUN rm -rf /var/www/html/*

# 复制 Winmail 文件
COPY webmail/ /var/www/html/

# 配置 Apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN echo "Listen \${PORT}" > /etc/apache2/ports.conf
RUN a2enmod rewrite

# 设置权限
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# 启动命令
CMD sed -i "s/\${PORT}/$PORT/g" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf && apache2-foreground
