#!/bin/bash

# Set default theme to luci-theme-argon
#uci set luci.main.mediaurlbase='/luci-static/argon'
#uci commit luci

# Disable IPV6
sed -i 's/^[^#].*option ula/#&/' /etc/config/network
uci set network.lan.ip6assign=0
uci set network.lan.delegate=0
uci set dhcp.lan.dhcpv6=disabled
uci set dhcp.lan.ra=disabled
uci set dhcp.cfg01411c.filter_aaaa=1

# Check file system during boot
# uci set fstab.@global[0].check_fs=1
# uci commit fstab

# Disable DHCP
uci set dhcp.lan.ignore=1

# 旁路由设置为主路由网关,DNS
uci set network.lan.gateway=192.168.1.1
uci set network.lan.broadcast=192.168.1.255
uci set network.lan.dns=222.246.129.80

uci commit network
uci commit dhcp

# 防火墙定义旁路由配置
echo 'iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE' >> /etc/firewall.user

#WEB后台无法打开
sed -i 's/^[^#].*listen_https/#&/' /etc/config/uhttpd

exit 0
