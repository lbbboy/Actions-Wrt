#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate


#hash 替换 
sed -i 's/3ec87f221e8905d4b6b8b3d207b7f7c4666c3bc8db7c1f06d4ae2e78f863b8f4/881cbf75efafe380b5adc91bfb1f68add5e29c9274eb950bb1e815c7a3622807/' \
  feeds/nss_packages/firmware/nss-firmware/Makefile



