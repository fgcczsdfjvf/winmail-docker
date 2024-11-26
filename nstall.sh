#!/bin/bash

# 下载 Winmail
wget http://www.winmail.cn/download/WM2012-WebMail-Linux.tar.gz
tar -zxvf WM2012-WebMail-Linux.tar.gz
rm -f WM2012-WebMail-Linux.tar.gz

# 设置权限
chmod -R 755 .
