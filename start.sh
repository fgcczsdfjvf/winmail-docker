#!/bin/bash

# 启动 Apache
apache2ctl start

# 保持容器运行
tail -f /dev/null
