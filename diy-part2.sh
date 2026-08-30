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
#sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# ==================== ✍️ 自定义修改区域 ====================
WRT_THEME="material"      # 默认主题
WRT_NAME="OWRT"           # 默认主机名
WRT_SSID="OWRT"           # 默认WIFI名称
WRT_WORD="12345678"       # 默认WIFI密码
WRT_IP="192.168.123.1"    # 默认网关IP
# ==========================================================

# 1. 修改无线配置 (双重保险，完美兼容 25.12 最新 uc 模板与旧版 sh 脚本)
WIFI_SH=$(find ./target/linux/{mediatek/filogic,qualcommax}/base-files/etc/uci-defaults/ -type f -name "*set-wireless.sh" 2>/dev/null)
WIFI_UC="./package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc"

if [ -n "$WIFI_SH" ] && [ -f "$WIFI_SH" ]; then
    sed -i "s/BASE_SSID='.*'/BASE_SSID='${WRT_SSID}'/g" "$WIFI_SH"
    sed -i "s/BASE_WORD='.*'/BASE_WORD='${WRT_WORD}'/g" "$WIFI_SH"
fi

if [ -f "$WIFI_UC" ]; then
    sed -i "s/ssid\s*[:=]\s*['\"].*['\"]/ssid: '${WRT_SSID}'/g" "$WIFI_UC"
    sed -i "s/key\s*[:=]\s*['\"].*['\"]/key: '${WRT_WORD}'/g" "$WIFI_UC"
    sed -i "s/encryption\s*[:=]\s*['\"].*['\"]/encryption: 'psk2'/g" "$WIFI_UC"
fi

# 2. 修改默认网络、主机名与网段 (精准匹配，防破坏全局系统级 IP 规则)
CFG_FILE="./package/base-files/files/bin/config_generate"
if [ -f "$CFG_FILE" ]; then
    sed -i "s/lan) ipad=\${ipaddr:-\"192.168.[0-9]*.[0-9]*\"}/lan) ipad=\${ipaddr:-\"${WRT_IP}\"}/g" "$CFG_FILE"
    sed -i "s/hostname='.*'/hostname='${WRT_NAME}'/g" "$CFG_FILE"
    sed -i "s/hostname:-\".*\"/hostname:-\"$WRT_NAME\"/g" "$CFG_FILE"
fi

# 3. 修改系统默认主题 (直接强制替换整个 LuCI 核心集合的默认推荐项)
LUCI_COLL=$(find ./feeds/luci/collections/ -type f -name "Makefile" 2>/dev/null)
if [ -n "$LUCI_COLL" ]; then
    sed -i "s/+luci-theme-[a-zA-Z0-9_-]*/+luci-theme-${WRT_THEME}/g" $LUCI_COLL
fi

# 4. 修改登录后台后的 immortalwrt.lan 快捷链接关联 IP
FLASH_JS=$(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js" 2>/dev/null)
if [ -n "$FLASH_JS" ]; then
    sed -i "s/192\.168\.1\.1/${WRT_IP}/g" $FLASH_JS
fi

echo "✅ OpenWrt 默认配置魔改成功！"


# 隐藏顶部左侧的品牌文字
cat >> package/feeds/luci/luci-theme-material/htdocs/luci-static/material/custom.css <<'EOF'

a.brand {
    display: none !important;
}
EOF



