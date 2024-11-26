#!/bin/bash
cd /var/www/html
rm -rf *
wget --no-check-certificate https://www.winmail.cn/download/WM2012-WebMail-Linux.tar.gz
if [ $? -eq 0 ]; then
    tar -zxvf WM2012-WebMail-Linux.tar.gz
    rm -f WM2012-WebMail-Linux.tar.gz
    if [ ! -f "index.php" ]; then
        echo "Error: index.php not found after extraction"
        exit 1
    fi
else
    echo "Error: Failed to download Winmail"
    exit 1
fi
