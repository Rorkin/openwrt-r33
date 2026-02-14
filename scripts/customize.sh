#!/bin/bash
set -e

PROXY_CORE="${1:-xray}"

echo "==========================================="
echo "  Customizing HC5861B (极路由3 Pro)"
echo "  Proxy core: $PROXY_CORE"
echo "==========================================="

CFG="package/base-files/files/bin/config_generate"

# =========================================
# 1. LAN IP → 192.168.10.1
# =========================================
sed -i 's/192\.168\.1\.1/192.168.10.1/g' "$CFG"
grep -q "192.168.10.1" "$CFG" && echo "✅ LAN IP → 192.168.10.1" || { echo "❌ IP change failed"; exit 1; }

# =========================================
# 2. 主机名
# =========================================
sed -i "s/hostname='OpenWrt'/hostname='HiWiFi-3Pro'/g" "$CFG"
echo "✅ Hostname → HiWiFi-3Pro"

# =========================================
# 3. 时区 → 中国
# =========================================
sed -i "s/timezone='UTC'/timezone='CST-8'/g" "$CFG"
if ! grep -q "zonename='Asia/Shanghai'" "$CFG"; then
  sed -i "/timezone='CST-8'/a\\\t\tset system.@system[0].zonename='Asia/Shanghai'" "$CFG"
fi
echo "✅ Timezone → CST-8 (Asia/Shanghai)"

# =========================================
# 4. 根据选择配置代理核心
# =========================================
case "$PROXY_CORE" in
  xray)
    cat >> .config << 'CORE'
# --- Xray only ---
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Xray=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox is not set
CONFIG_PACKAGE_xray-core=y
CORE
    echo "✅ Core: Xray (推荐，VLESS/VMess/Trojan/REALITY)"
    ;;
  sing-box)
    cat >> .config << 'CORE'
# --- SingBox only ---
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Xray is not set
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox=y
CONFIG_PACKAGE_sing-box=y
CORE
    echo "✅ Core: SingBox (Hysteria2/TUIC/VLESS)"
    ;;
  lightweight)
    cat >> .config << 'CORE'
# --- 轻量方案：shadowsocks-libev + xray 分流 ---
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Server=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox is not set
CONFIG_PACKAGE_xray-core=y
CONFIG_PACKAGE_shadowsocks-libev-ss-local=y
CONFIG_PACKAGE_shadowsocks-libev-ss-redir=y
CONFIG_PACKAGE_shadowsocks-libev-ss-tunnel=y
CORE
    echo "✅ Core: Lightweight (SS-libev + Xray, 省内存)"
    ;;
  all)
    cat >> .config << 'CORE'
# --- 全部核心 ---
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_V2ray_Plugin=y
CONFIG_PACKAGE_xray-core=y
CONFIG_PACKAGE_sing-box=y
CONFIG_PACKAGE_shadowsocks-libev-ss-local=y
CONFIG_PACKAGE_shadowsocks-libev-ss-redir=y
CONFIG_PACKAGE_shadowsocks-libev-ss-tunnel=y
CONFIG_PACKAGE_shadowsocks-libev-ss-server=y
CONFIG_PACKAGE_shadowsocks-rust-sslocal=y
CONFIG_PACKAGE_simple-obfs-client=y
CONFIG_PACKAGE_v2ray-plugin=y
CORE
    echo "✅ Core: ALL (128MB NAND 装得下，但 128MB RAM 同时跑会紧张)"
    ;;
esac

echo "==========================================="
echo "  Done"
echo "==========================================="
