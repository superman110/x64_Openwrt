#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# KERNEL_5.19
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.19/g' target/linux/x86/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.11/g' package/base-files/files/bin/config_generate

# Disable IPv6
#sed -i 's/def_bool y/def_bool n/g' config/Config-build.in

# Modify network display
sed -i 's/\[e\]/eth/g' package/lean/autocore/files/x86/sbin/ethinfo
sed -i 's/grep \-v \"\@/awk \-F\"\@/g' package/lean/autocore/files/x86/sbin/ethinfo
sed -i "s/| grep \-v /\'\{print \$1\}\'/g" package/lean/autocore/files/x86/sbin/ethinfo
sed -i 's/\"\\\.\"//g' package/lean/autocore/files/x86/sbin/ethinfo
sed -i 's/4096/65535/g' package/lean/autocore/files/x86/index.htm

#Optimize network parameters
sed -i '$ a net.netfilter.nf_conntrack_icmp_timeout=10' package/base-files/files/etc/sysctl.conf
sed -i '$ a net.netfilter.nf_conntrack_tcp_timeout_syn_recv=5' package/base-files/files/etc/sysctl.conf
sed -i '$ a net.netfilter.nf_conntrack_tcp_timeout_syn_sent=5' package/base-files/files/etc/sysctl.conf
sed -i '$ a net.netfilter.nf_conntrack_tcp_timeout_established=600' package/base-files/files/etc/sysctl.conf
sed -i '$ a net.netfilter.nf_conntrack_tcp_timeout_fin_wait=10' package/base-files/files/etc/sysctl.conf
sed -i '$ a net.netfilter.nf_conntrack_tcp_timeout_time_wait=10' package/base-files/files/etc/sysctl.conf
sed -i '$ a net.netfilter.nf_conntrack_tcp_timeout_close_wait=10' package/base-files/files/etc/sysctl.conf
sed -i '$ a net.netfilter.nf_conntrack_tcp_timeout_last_ack=10' package/base-files/files/etc/sysctl.conf
sed -i '$ a net.core.somaxconn=65535' package/base-files/files/etc/sysctl.conf


echo '
CONFIG_X86_INTEL_PSTATE=y
' >>./target/linux/x86/config-6.1

#openssl 1.1.1
rm -rf package/libs/openssl
svn export https://github.com/openwrt/openwrt/branches/openwrt-22.03/package/libs/openssl package/libs/openssl

#添加ssr-plus
git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus

git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall

#添加passwall2
svn export https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2

#添加openclash
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

mkdir -p files/etc/openclash/core
CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-amd64.tar.gz"
CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/master/premium\?ref\=core | grep download_url | grep amd64 | grep -v "v3" | awk -F '"' '{print $4}')
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
wget -qO- $CLASH_DEV_URL | tar xOvz > files/etc/openclash/core/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
chmod +x files/etc/openclash/core/clash*

#添加adguardhome
rm -rf feeds/packages/net/adguardhome
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
mkdir -p files/usr/bin/AdGuardHome
AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases | grep /AdGuardHome_linux_amd64 | awk -F '"' '{print $4}' | sed -n '1p')
wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome/AdGuardHome
chmod +x files/usr/bin/AdGuardHome/AdGuardHome

#添加smartdns
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/applications/luci-app-smartdns
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

#添加mosdns
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
svn export https://github.com/sbwml/luci-app-mosdns/trunk/luci-app-mosdns package/luci-app-mosdns
svn export https://github.com/sbwml/luci-app-mosdns/trunk/mosdns package/mosdns

#添加istore
svn export https://github.com/linkease/istore-ui/trunk/app-store-ui package/app-store-ui
svn export https://github.com/linkease/istore/trunk/luci package/luci-app-store

# luci-app-irqbalance
svn co https://github.com/QiuSimons/OpenWrt-Add/trunk/luci-app-irqbalance package/luci-app-irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

./scripts/feeds update -a
./scripts/feeds install -a
