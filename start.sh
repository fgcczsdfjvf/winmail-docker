#!/bin/bash

# 确保Apache监听正确的端口
sed -i "s/80/8080/g" /etc/apache2/ports.conf
sed -i "s/80/8080/g" /etc/apache2/sites-enabled/000-default.conf

# 启动Apache
apache2ctl -D FOREGROUND
