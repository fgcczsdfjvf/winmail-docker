FROM php:7.4-apache

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -y \
    wget \
    libzip-dev \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
RUN rm -rf /var/www/html/*

RUN wget http://www.winmail.cn/download/WM2012-WebMail-Linux.tar.gz \
    && tar -zxvf WM2012-WebMail-Linux.tar.gz \
    && rm -f WM2012-WebMail-Linux.tar.gz

RUN chown -R www-data:www-data /var/www/html

EXPOSE ${PORT}

CMD ["apache2-foreground"]
