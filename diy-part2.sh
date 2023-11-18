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

#添加额外软件包

svn co https://github.com/kenzok8/small-package/trunk/luci-app-bypass package/luci-app-bypass
sed -i 's/luci-lib-ipkg/luci-base/g' package/luci-app-bypass/Makefile

svn co https://github.com/kenzok8/small-package/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

svn co https://github.com/kenzok8/small-package/trunk/brook package/brook
svn co https://github.com/kenzok8/small-package/trunk/chinadns-ng package/chinadns-ng
svn co https://github.com/kenzok8/small-package/trunk/dns2socks package/dns2socks
svn co https://github.com/kenzok8/small-package/trunk/dns2tcp package/dns2tcp
svn co https://github.com/kenzok8/small-package/trunk/hysteria package/hysteria
svn co https://github.com/kenzok8/small-package/trunk/ipt2socks package/ipt2socks
svn co https://github.com/kenzok8/small-package/trunk/pdnsd-alt package/pdnsd-alt
svn co https://github.com/kenzok8/small-package/trunk/shadowsocks-libev package/shadowsocks-libev
svn co https://github.com/kenzok8/small-package/trunk/shadowsocks-rust package/shadowsocks-rust
svn co https://github.com/kenzok8/small-package/trunk/shadowsocksr-libev package/shadowsocksr-libev
svn co https://github.com/kenzok8/small-package/trunk/simple-obfs package/simple-obfs
svn co https://github.com/kenzok8/small-package/trunk/ssocks package/ssocks
svn co https://github.com/kenzok8/small-package/trunk/trojan-go package/trojan-go
svn co https://github.com/kenzok8/small-package/trunk/trojan-plus package/trojan-plus
svn co https://github.com/kenzok8/small-package/trunk/trojan package/trojan
svn co https://github.com/kenzok8/small-package/trunk/v2ray-core package/v2ray-core
svn co https://github.com/kenzok8/small-package/trunk/v2ray-geodata package/v2ray-geodata
svn co https://github.com/kenzok8/small-package/trunk/v2ray-plugin package/v2ray-plugin
svn co https://github.com/kenzok8/small-package/trunk/v2raya package/v2raya
svn co https://github.com/kenzok8/small-package/trunk/xray-core package/xray-core
svn co https://github.com/kenzok8/small-package/trunk/xray-plugin package/xray-plugin

svn co https://github.com/kenzok8/small-package/trunk/luci-lib-taskd package/luci-lib-taskd
svn co https://github.com/kenzok8/small-package/trunk/luci-lib-xterm package/luci-lib-xterm
svn co https://github.com/kenzok8/small-package/trunk/taskd package/taskd
svn co https://github.com/kenzok8/small-package/trunk/lua-neturl package/lua-neturl
svn co https://github.com/kenzok8/small-package/trunk/lua-maxminddb package/lua-maxminddb
svn co https://github.com/kenzok8/small-package/trunk/microsocks package/microsocks
svn co https://github.com/kenzok8/small-package/trunk/gn package/gn
svn co https://github.com/kenzok8/small-package/trunk/naiveproxy package/naiveproxy
svn co https://github.com/kiddin9/openwrt-packages/trunk/redsocks2 package/redsocks2
svn co https://github.com/kenzok8/small-package/trunk/tcping package/tcping

#添加adguardhome
#rm -rf feeds/packages/net/adguardhome
svn co https://github.com/kenzok8/small-package/trunk/luci-app-adguardhome package/luci-app-adguardhome

#添加smartdns
rm -rf feeds/packages/net/smartdns
svn co https://github.com/kenzok8/small-package/trunk/smartdns package/smartdns
svn co https://github.com/kenzok8/small-package/trunk/luci-app-smartdns package/luci-app-smartdns

#mosdns
#rm -rf feeds/packages/net/mosdns
#svn co https://github.com/sbwml/luci-app-mosdns package/mosdns
#svn co https://github.com/sbwml/v2ray-geodata package/geodata
#svn co https://github.com/kenzok8/small-package/trunk/mosdns package/mosdns
#svn co https://github.com/kenzok8/small-package/trunk/luci-app-mosdns package/luci-app-mosdns

#添加istore
svn co https://github.com/kenzok8/small-package/trunk/luci-app-store package/luci-app-store
sed -i 's/luci-lib-ipkg/luci-base/g' package/luci-app-store/Makefile

# luci-app-irqbalance
svn co https://github.com/QiuSimons/OpenWrt-Add/trunk/luci-app-irqbalance package/luci-app-irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

./scripts/feeds update -a
./scripts/feeds install -a
