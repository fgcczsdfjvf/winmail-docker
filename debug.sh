#!/bin/bash
echo "=== Directory Contents ==="
ls -la /app
echo
echo "=== System Info ==="
uname -a
echo
echo "=== Process Status ==="
ps aux | grep winmail
echo
echo "=== Port Status ==="
netstat -tulpn
