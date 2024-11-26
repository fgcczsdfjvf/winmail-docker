FROM ubuntu
MAINTAINER fgcczsdfjvf

RUN apt-get update && \
    apt-get install -y apache2 \
    php \
    php-mysql \
    php-gd \
    php-curl \
    php-xml \
    php-mbstring \
    php-zip \
    libapache2-mod-php \
    wget

WORKDIR /var/www/html
RUN rm -rf /var/www/html/*

RUN wget http://www.winmail.cn/download/WM2012-WebMail-Linux.tar.gz && \
    tar -zxvf WM2012-WebMail-Linux.tar.gz && \
    rm -f WM2012-WebMail-Linux.tar.gz

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
