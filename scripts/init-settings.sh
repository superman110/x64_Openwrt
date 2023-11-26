#!/bin/bash

# Set default theme to luci-theme-argon
#uci set luci.main.mediaurlbase='/luci-static/argon'
#uci commit luci

# Disable IPV6 ula prefix
# sed -i 's/^[^#].*option ula/#&/' /etc/config/network

# Check file system during boot
# uci set fstab.@global[0].check_fs=1
# uci commit fstab

#WEB后台无法打开
sed -i 's/list listen_https/#list listen_https/g' /etc/config/uhttpd

exit 0
