#!/bin/bash
wget http://www.winmail.cn/download/WM2012-WebMail-Linux.tar.gz
tar -zxvf WM2012-WebMail-Linux.tar.gz
rm -f WM2012-WebMail-Linux.tar.gz
chown -R www-data:www-data /var/www/html
